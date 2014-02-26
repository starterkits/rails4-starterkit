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

ActiveRecord::Schema.define(version: 20140204233952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider",      null: false
    t.string   "proid",         null: false
    t.string   "token"
    t.string   "refresh_token"
    t.string   "secret"
    t.datetime "expires_at"
    t.string   "username"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["provider"], :name => "index_authentications_on_provider"
    t.index ["user_id"], :name => "fk__authentications_user_id"
  end

  create_table "oauth_caches", id: false, force: true do |t|
    t.integer  "authentication_id", null: false
    t.text     "data_json",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["authentication_id"], :name => "fk__oauth_caches_authentication_id"
    t.index ["authentication_id"], :name => "index_oauth_caches_on_authentication_id"
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item", "table", "month", "year"], :name => "index_rails_admin_histories"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image_url"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.index ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
    t.index ["email"], :name => "index_users_on_email", :unique => true, :case_sensitive => false
    t.index ["is_admin"], :name => "index_users_on_is_admin"
    t.index ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
    t.index ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  end

end
