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

ActiveRecord::Schema.define(version: 20150708222833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "granted",    default: false
  end

  add_index "badges", ["id", "type"], name: "index_badges_on_id_and_type", using: :btree
  add_index "badges", ["user_id"], name: "index_badges_on_user_id", using: :btree

  create_table "bookfrags", force: :cascade do |t|
    t.string   "fragment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "book_id"
  end

  create_table "challenge_statistics", force: :cascade do |t|
    t.string   "type"
    t.string   "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "challenge_id"
  end

  add_index "challenge_statistics", ["challenge_id"], name: "index_challenge_statistics_on_challenge_id", using: :btree
  add_index "challenge_statistics", ["id", "type"], name: "index_challenge_statistics_on_id_and_type", using: :btree

  create_table "challenges", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.date     "begindate"
    t.date     "enddate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "chapters_to_read"
    t.text     "welcome_message"
    t.string   "dates_to_skip"
    t.integer  "memberships_count"
    t.integer  "readings_count"
  end

  add_index "challenges", ["owner_id"], name: "index_challenges_on_owner_id", using: :btree

  create_table "chapter_challenges", force: :cascade do |t|
    t.integer  "challenge_id"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapter_challenges", ["challenge_id"], name: "index_chapter_challenges_on_challenge_id", using: :btree
  add_index "chapter_challenges", ["chapter_id"], name: "index_chapter_challenges_on_chapter_id", using: :btree

  create_table "chapters", force: :cascade do |t|
    t.string   "book_name"
    t.integer  "chapter_number"
    t.integer  "chapter_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "book_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "invisible",        default: false
    t.integer  "flag_count",       default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "group_statistics", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "value"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "group_statistics", ["group_id"], name: "index_group_statistics_on_group_id", using: :btree
  add_index "group_statistics", ["id", "type"], name: "index_group_statistics_on_id_and_type", using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "challenge_id"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "ave_sequential_reading_count",    default: 0
    t.integer  "ave_punctual_reading_percentage", default: 0
    t.integer  "ave_progress_percentage",         default: 0
    t.integer  "memberships_count"
  end

  add_index "groups", ["challenge_id"], name: "index_groups_on_challenge_id", using: :btree
  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "membership_readings", force: :cascade do |t|
    t.integer  "membership_id"
    t.integer  "reading_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "on_schedule"
  end

  add_index "membership_readings", ["membership_id", "reading_id"], name: "index_membership_readings_on_membership_id_and_reading_id", using: :btree
  add_index "membership_readings", ["membership_id"], name: "index_membership_readings_on_membership_id", using: :btree
  add_index "membership_readings", ["reading_id"], name: "index_membership_readings_on_reading_id", using: :btree

  create_table "membership_statistics", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "type"
    t.string   "value"
    t.integer  "membership_id"
  end

  add_index "membership_statistics", ["id", "type"], name: "index_membership_statistics_on_id_and_type", using: :btree
  add_index "membership_statistics", ["membership_id"], name: "index_membership_statistics_on_membership_id", using: :btree
  add_index "membership_statistics", ["user_id"], name: "index_membership_statistics_on_user_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bible_version",                default: "ASV"
    t.integer  "group_id"
    t.integer  "rec_sequential_reading_count", default: 0
    t.integer  "punctual_reading_percentage",  default: 0
    t.integer  "progress_percentage",          default: 0
  end

  add_index "memberships", ["challenge_id", "user_id"], name: "index_memberships_on_challenge_id_and_user_id", using: :btree
  add_index "memberships", ["challenge_id"], name: "index_memberships_on_challenge_id", using: :btree
  add_index "memberships", ["group_id", "user_id"], name: "index_memberships_on_group_id_and_user_id", using: :btree
  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "readings", force: :cascade do |t|
    t.integer "chapter_id"
    t.integer "challenge_id"
    t.date    "read_on"
    t.text    "discussion"
  end

  add_index "readings", ["challenge_id"], name: "index_readings_on_challenge_id", using: :btree
  add_index "readings", ["chapter_id"], name: "index_readings_on_chapter_id", using: :btree

  create_table "user_statistics", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "type"
    t.string   "value"
  end

  add_index "user_statistics", ["id", "type"], name: "index_user_statistics_on_id_and_type", using: :btree
  add_index "user_statistics", ["user_id"], name: "index_user_statistics_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.string   "authentication_token"
    t.string   "time_zone",              default: "EST"
    t.integer  "preferred_reading_hour", default: 12
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "verses", force: :cascade do |t|
    t.string   "version"
    t.string   "book_name"
    t.integer  "chapter_number"
    t.integer  "verse_number"
    t.text     "versetext"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_index"
  end

  add_index "verses", ["chapter_index"], name: "index_verses_on_chapter_index", using: :btree

  add_foreign_key "badges", "users"
end
