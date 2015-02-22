class League < ActiveRecord::Base
  validates :name, :presence => true

  has_many :teams
  has_many :games

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
      # generate algorithm
    end
  end
end
