class League < ActiveRecord::Base
  validates :name, :presence => true

  has_many :teams
  has_many :games

  validates :days_of_week_data, :presence => true
  validates :games_per_day, :presence => true, :numericality => true
  validates :games_per_team, :presence => true, :numericality => true

  state_machine :state, :initial => :new do
    event :start do
      transition :new => :started
    end

    event :complete do
      transition :started => :completed
    end

    after_transition :on => :start, :do => :generate_games
  end

  def generate_games
    if self.started?
      raise "already has games" if self.games.present?

      teams_games = Hash[
        self.teams.map do |team|
          [team, []]
        end
      ]

      team_available_opponents = Hash[
        self.teams.map do |team|
          [team, self.teams - [team]]
        end
      ]

      # Step 1) Generate all permutations
      self.teams.shuffle.each do |team|
        (self.games_per_team - teams_games[team].count).times do
          # Find a candidate
          # Within all available candidates, find the least occupied one
          opponent = team_available_opponents[team].shuffle.map do |opp|
            [opp, teams_games[opp].count]
          end.min do |x, y|
            x.second <=> y.second
          end

          if opponent.count == self.games_per_team
            raise "Oops selected an opponent that's maxed out"
          end

          game = Game.new(
            :home_team => team,
            :away_team => opponent.first,
            :league => self
          )
          teams_games[team] << game
          teams_games[opponent.first] << game


          team_available_opponents[team] -= [opponent]
          # exhausted, reset
          if team_available_opponents.blank?
            team_available_opponents = self.teams - team
          end
        end
      end

      # Check
      unless teams_games.values.map(&:count).uniq == [self.games_per_team]
        raise "Incorrect # of games #{teams_games.inspect}"
      end

      # Step 2) Assign date to games
      # Find the closest date to start based on days of week
      days_away = self.days_of_week.map do |dw|
        days_away = dw - Time.now.wday
        days_away = days_away.abs + 7 if days_away < 0
        days_away
      end.min.days

      date = Time.now.change(:hour => 12,
                             :minute => 0,
                             :second => 0) + days_away
      games_assigned_for_date = 0

      unassigned_games = teams_games.clone
      while unassigned_games.values.flatten.present?
        teams_unassigned_count = Hash[unassigned_games.map do |team, games|
          [team, games.count]
        end]

        # Find the team with maximum # of unassigned games
        team = teams_unassigned_count.keys.shuffle.max do |x, y|
          teams_unassigned_count[x] <=> teams_unassigned_count[y]
        end

        # Within the unassigned games of the selected team,
        # find the opponment/game with the max # of unassigned games
        potential_game_opponents = unassigned_games[team].map do |game|
          [game, ([game.home_team, game.away_team] - [team]).first]
        end
        game = potential_game_opponents.max do |x, y|
          teams_unassigned_count[x.second] <=>  teams_unassigned_count[y.second]
        end.first

        game.start_time = date
        game.end_time = date + 1.hour
        game.save!

        unassigned_games[game.home_team] -= [game]
        unassigned_games[game.away_team] -= [game]
        games_assigned_for_date += 1

        # Finished with date, advance
        if games_assigned_for_date == self.games_per_day
          # Advance date
          next_wday = self.days_of_week[
            (self.days_of_week.index(date.wday) + 1) % self.days_of_week.count
          ]

          days_away = next_wday - date.wday
          days_away += 7 if days_away < 0

          date += days_away.days
          raise if date.wday == 0
          games_assigned_for_date = 0
        end
      end
    end

    teams_games.values.flatten
  end

  def days_of_week
    (self.days_of_week_data || '').split(',').map do |x|
      x.to_i
    end
  end
end
