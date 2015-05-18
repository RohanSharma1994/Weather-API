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

ActiveRecord::Schema.define(version: 20150518115120) do

  create_table "days", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "weather_station_id"
  end

  add_index "days", ["weather_station_id"], name: "index_days_on_weather_station_id"

  create_table "observations", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "day_id"
    t.string   "source"
  end

  add_index "observations", ["day_id"], name: "index_observations_on_day_id"

  create_table "rainfalls", force: :cascade do |t|
    t.float    "rainfall_amount"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "observation_id"
  end

  add_index "rainfalls", ["observation_id"], name: "index_rainfalls_on_observation_id"

  create_table "temperatures", force: :cascade do |t|
    t.float    "current_temperature"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "observation_id"
  end

  add_index "temperatures", ["observation_id"], name: "index_temperatures_on_observation_id"

  create_table "weather_stations", force: :cascade do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.string   "post_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "winds", force: :cascade do |t|
    t.float    "wind_speed"
    t.string   "wind_direction"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "observation_id"
  end

  add_index "winds", ["observation_id"], name: "index_winds_on_observation_id"

end
