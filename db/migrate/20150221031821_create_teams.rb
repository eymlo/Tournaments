class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.references :league, index: true
      t.text :description

      t.timestamps
    end
  end
end
