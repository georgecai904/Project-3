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

ActiveRecord::Schema.define(version: 20150424035905) do

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fetches", force: :cascade do |t|
    t.datetime "fetchtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rainfalls", force: :cascade do |t|
    t.decimal  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stations", force: :cascade do |t|
    t.string   "name"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "city_id"
  end

  add_index "stations", ["city_id"], name: "index_stations_on_city_id"

  create_table "temperatures", force: :cascade do |t|
    t.decimal  "current"
    t.decimal  "dew"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weathers", force: :cascade do |t|
    t.string   "source"
    t.string   "time"
    t.integer  "rainfall_id"
    t.integer  "temperature_id"
    t.integer  "wind_id"
    t.integer  "station_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "fetch_id"
  end

  add_index "weathers", ["fetch_id"], name: "index_weathers_on_fetch_id"
  add_index "weathers", ["rainfall_id"], name: "index_weathers_on_rainfall_id"
  add_index "weathers", ["station_id"], name: "index_weathers_on_station_id"
  add_index "weathers", ["temperature_id"], name: "index_weathers_on_temperature_id"
  add_index "weathers", ["wind_id"], name: "index_weathers_on_wind_id"

  create_table "winds", force: :cascade do |t|
    t.decimal  "speed"
    t.string   "direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
