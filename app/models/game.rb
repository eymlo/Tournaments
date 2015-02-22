class Game < ActiveRecord::Base
  belongs_to :home_team,
    :class_name => 'Team',
    :foreign_key => 'home_team_id'
  belongs_to :away_team,
    :class_name => 'Team',
    :foreign_key => 'away_team_id'

  validates :home_team, :presence => true
  validates :away_team, :presence => true

  scope :completed_games, where("home_score is not null and away_score is not null")
end
