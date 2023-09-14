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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140524150612) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "billingsubscriptions", :force => true do |t|
    t.string   "amount"
    t.string   "billing_period"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "token"
    t.string   "finger_print"
    t.integer  "card_number"
    t.integer  "card_code"
    t.integer  "plan_id"
    t.string   "subscriber_id"
    t.string   "customer_id"
  end

  create_table "constantplans", :force => true do |t|
    t.string   "name"
    t.integer  "contacts"
    t.integer  "sequence"
    t.integer  "monthly_emails"
    t.integer  "price"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "stripe_plan_id"
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "website"
    t.string   "primary_email"
    t.string   "email2"
    t.string   "email3"
    t.string   "email4"
    t.string   "custom1"
    t.string   "custom2"
    t.string   "custom3"
    t.string   "last_reply_date"
    t.integer  "account_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
  end

  create_table "emails", :force => true do |t|
    t.string   "subject"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "step_id"
    t.text     "body"
  end

  create_table "histories", :force => true do |t|
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "identities", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "identities", ["user_id"], :name => "index_identities_on_user_id"

  create_table "imapsettings", :force => true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "server"
    t.integer  "account_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "nextemails", :force => true do |t|
    t.integer  "email_id"
    t.integer  "sequence_id"
    t.integer  "step_id"
    t.string   "status"
    t.text     "response"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "queued_id"
    t.integer  "sequencemembership_id"
    t.datetime "date"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.integer  "contacts"
    t.integer  "sequences"
    t.integer  "monthly_emails"
    t.integer  "price"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "account_id"
    t.integer  "constant_plan_id"
  end

  create_table "queueds", :force => true do |t|
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sentemails", :force => true do |t|
    t.integer  "email_id"
    t.integer  "sequence_id"
    t.integer  "step_id"
    t.integer  "history_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "date"
  end

  create_table "sequencememberships", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "sequence_id"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "step_id"
  end

  create_table "sequences", :force => true do |t|
    t.string   "name"
    t.boolean  "stop_toggle"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "account_id"
  end

  create_table "smtpsettings", :force => true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "server"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "account_id"
  end

  create_table "steps", :force => true do |t|
    t.integer  "sequence_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "step_number"
    t.integer  "delay"
    t.integer  "schedule"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "company"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
