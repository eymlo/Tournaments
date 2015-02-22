# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150222074512) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "home_score"
    t.integer  "away_score"
    t.boolean  "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "league_id",    null: false
    t.integer  "ordinal"
  end

  add_index "games", ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
  add_index "games", ["home_team_id"], name: "index_games_on_home_team_id", using: :btree
  add_index "games", ["league_id"], name: "index_games_on_league_id", using: :btree

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "league_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["league_id"], name: "index_teams_on_league_id", using: :btree

end
