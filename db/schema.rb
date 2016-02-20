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

ActiveRecord::Schema.define(version: 20160220213208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.string   "day",          null: false
    t.integer  "start_time",   null: false
    t.integer  "end_time",     null: false
    t.integer  "volunteer_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "longitude",   precision: 9, scale: 6
    t.decimal  "latitude",    precision: 9, scale: 6
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
  end

  create_table "match_proposals", force: :cascade do |t|
    t.string   "day",        null: false
    t.integer  "start_time", null: false
    t.integer  "end_time",   null: false
    t.integer  "client_id",  null: false
    t.string   "status",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_requests", force: :cascade do |t|
    t.integer  "volunteer_id",      null: false
    t.string   "status",            null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "match_proposal_id", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "client_id",        null: false
    t.integer  "volunteer_id",     null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "day",              null: false
    t.integer  "start_time",       null: false
    t.integer  "end_time",         null: false
    t.integer  "match_request_id"
  end

  create_table "specialties", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specialties_volunteers", id: false, force: :cascade do |t|
    t.integer "volunteer_id"
    t.integer "specialty_id"
  end

  add_index "specialties_volunteers", ["volunteer_id", "specialty_id"], name: "vol_specialty_volunteer_id_index", unique: true, using: :btree

  create_table "volunteers", force: :cascade do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "longitude",   precision: 9, scale: 6
    t.decimal  "latitude",    precision: 9, scale: 6
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
  end

end
