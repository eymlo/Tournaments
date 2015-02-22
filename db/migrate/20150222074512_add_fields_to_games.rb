class AddFieldsToGames < ActiveRecord::Migration
  def change
    add_column :games, :league_id, :integer, :null => false
    add_column :games, :ordinal, :integer

    add_index :games, :league_id
  end
end
