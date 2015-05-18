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

ActiveRecord::Schema.define(version: 20150512120723) do

  create_table "days", force: :cascade do |t|
    t.date     "date"
    t.integer  "WeatherStation_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "observations", force: :cascade do |t|
    t.string   "description"
    t.float    "temperature"
    t.float    "rain"
    t.string   "source"
    t.integer  "Day_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "predictions", force: :cascade do |t|
    t.float    "variance"
    t.float    "probability"
    t.time     "time"
    t.integer  "Day_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "rainfall_observations", force: :cascade do |t|
    t.float    "rainfall_amount"
    t.integer  "Observation_id"
    t.integer  "Prediction_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "temperature_observations", force: :cascade do |t|
    t.float    "current_temperature"
    t.integer  "Observation_id"
    t.integer  "Prediction_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "weather_stations", force: :cascade do |t|
    t.float    "lat"
    t.float    "lon"
    t.string   "post_code"
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wind_observations", force: :cascade do |t|
    t.float    "wind_speed"
    t.float    "wind_direction"
    t.integer  "Observation_id"
    t.integer  "Prediction_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
