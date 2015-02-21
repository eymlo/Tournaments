class Team < ActiveRecord::Base
  belongs_to :league

  validates :league, :presence => true
end
