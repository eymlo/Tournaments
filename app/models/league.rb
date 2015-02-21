class League < ActiveRecord::Base
  validates :name, :presence => true
end
