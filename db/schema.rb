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

ActiveRecord::Schema.define(version: 20160123173709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "meeting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_id"], name: "index_events_on_meeting_id", using: :btree
    t.index ["user_id", "meeting_id"], name: "index_events_on_user_id_and_meeting_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "secret"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider"], name: "index_identities_on_provider", using: :btree
    t.index ["secret"], name: "index_identities_on_secret", using: :btree
    t.index ["token"], name: "index_identities_on_token", using: :btree
    t.index ["uid", "provider", "user_id"], name: "index_identities_on_uid_and_provider_and_user_id", unique: true, using: :btree
    t.index ["uid"], name: "index_identities_on_uid", using: :btree
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "meetings", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "meeting_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.jsonb    "info",       default: {}, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["info"], name: "index_meetings_on_info", using: :gin
    t.index ["meeting_id"], name: "index_meetings_on_meeting_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_meetings_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "",    null: false
    t.string   "name",               default: "",    null: false
    t.string   "username",           default: "",    null: false
    t.string   "first_name",         default: "",    null: false
    t.string   "last_name",          default: "",    null: false
    t.string   "avatar",             default: ""
    t.string   "phone"
    t.string   "pin"
    t.boolean  "phone_verified",     default: false, null: false
    t.jsonb    "meta",               default: {},    null: false
    t.jsonb    "preferences",        default: {},    null: false
    t.string   "encrypted_password", default: "",    null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "events", "meetings"
  add_foreign_key "events", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "meetings", "users"
end
