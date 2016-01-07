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

ActiveRecord::Schema.define(version: 20150903122140) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appearances", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "appearances", ["group_id"], name: "index_appearances_on_group_id", using: :btree
  add_index "appearances", ["user_id"], name: "index_appearances_on_user_id", using: :btree

  create_table "error_logs", force: :cascade do |t|
    t.integer  "user_log_id"
    t.string   "name"
    t.text     "message"
    t.text     "exception"
    t.text     "backtrace"
    t.boolean  "is_fixed",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "error_logs", ["user_log_id"], name: "index_error_logs_on_user_log_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "admin_name"
  end

  create_table "runs", force: :cascade do |t|
    t.integer  "group_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "status",     default: 0
    t.float    "duration",               null: false
    t.string   "name",                   null: false
  end

  add_index "runs", ["group_id"], name: "index_runs_on_group_id", using: :btree

  create_table "stocks", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "symbol",      null: false
    t.integer  "user_id",     null: false
    t.integer  "run_id"
    t.float    "start_price"
    t.float    "end_price"
  end

  add_index "stocks", ["run_id"], name: "index_stocks_on_run_id", using: :btree
  add_index "stocks", ["user_id"], name: "index_stocks_on_user_id", using: :btree

  create_table "user_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "remote_addr"
    t.string   "session_id"
    t.integer  "status"
    t.string   "method"
    t.string   "controller"
    t.string   "action"
    t.string   "domain"
    t.string   "request_uri"
    t.string   "url"
    t.string   "protocol"
    t.string   "format"
    t.string   "host"
    t.string   "port"
    t.text     "user_params"
    t.text     "user_session"
    t.string   "query_string"
    t.string   "http_accept"
    t.boolean  "ssl"
    t.boolean  "xhr"
    t.string   "referer"
    t.string   "http_user_agent"
    t.string   "server_software"
    t.string   "content_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "user_logs", ["user_id"], name: "index_user_logs_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_legacy"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "last_seen"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "image"
  end

  add_foreign_key "appearances", "groups"
  add_foreign_key "appearances", "users"
  add_foreign_key "runs", "groups"
  add_foreign_key "stocks", "users"
end
