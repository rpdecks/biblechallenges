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

ActiveRecord::Schema.define(version: 20150424154204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookfrags", force: :cascade do |t|
    t.string   "fragment",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "book_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "name",             limit: 255
    t.date     "begindate"
    t.date     "enddate"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "chapters_to_read", limit: 255
    t.text     "welcome_message"
  end

  create_table "chapter_challenges", force: :cascade do |t|
    t.integer  "challenge_id"
    t.integer  "chapter_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.string   "book_name",      limit: 255
    t.integer  "chapter_number"
    t.integer  "chapter_index"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "book_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
    t.boolean  "invisible",                    default: false
    t.integer  "flag_count",                   default: 0,     null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "membership_readings", force: :cascade do |t|
    t.integer  "membership_id"
    t.integer  "reading_id"
    t.string   "state",         limit: 255, default: "unread"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "bible_version", limit: 255, default: "ASV"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "username",               limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "time_zone",              limit: 255, default: "UTC"
    t.integer  "preferred_reading_hour",             default: 0
  end

  create_table "readings", force: :cascade do |t|
    t.integer  "chapter_id"
    t.integer  "challenge_id"
    t.date     "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "discussion"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "verses", force: :cascade do |t|
    t.string   "version",        limit: 255
    t.string   "book_name",      limit: 255
    t.integer  "chapter_number"
    t.integer  "verse_number"
    t.text     "versetext"
    t.integer  "book_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "chapter_index"
  end

end
