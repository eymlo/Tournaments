class Game < ActiveRecord::Base
  belongs_to :home_team,
    :class_name => 'Team',
    :foreign_key => 'home_team_id'
  belongs_to :away_team,
    :class_name => 'Team',
    :foreign_key => 'away_team_id'
  belongs_to :league,
    :class_name => 'League',
    :foreign_key => 'league_id'

  validates :home_team, :presence => true
  validates :away_team, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true

  scope :completed_games, where("home_score IS NOT NULL AND away_score IS NOT NULL")
end
