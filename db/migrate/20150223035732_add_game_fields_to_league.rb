class AddGameFieldsToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :days_of_week_data, :string
    add_column :leagues, :games_per_team, :integer
    add_column :leagues, :games_per_day, :integer
  end
end
