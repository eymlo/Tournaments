class Team < ActiveRecord::Base
  belongs_to :league

  validates :name, :presence => true
  validates :league, :presence => true

  # FIXME: Change the data model to avoid doing these queries
  def games_played
    @games_played = self.league.games.completed_games.where(
                      "home_team_id = ? or away_team_id = ?", self.id, self.id
                    ).count
  end

  def wins
    @wins ||= self.league.games.completed_games.where(
                "(home_team_id = ? and home_score > away_score) or
                (away_team_id = ? and away_score > home_score)",
                self.id, self.id
              ).count
  end

  def losses
    @losses ||= self.league.games.completed_games.where(
                  "(home_team_id = ? and home_score < away_score) or
                  (away_team_id = ? and away_score < home_score)",
                  self.id, self.id
                ).count
  end

  def ties
    @ties ||= self.league.games.completed_games.where(
                "(home_team_id = ? and home_score = away_score) or
                (away_team_id = ? and away_score = home_score)",
                self.id, self.id
              ).count
  end

  def league_points
    self.wins*3 + self.ties
  end
end
