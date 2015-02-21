class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :home_team, index: true
      t.references :away_team, index: true
      t.integer :home_score
      t.integer :away_score
      t.boolean :deleted

      t.timestamps
    end
  end
end
