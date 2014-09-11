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

ActiveRecord::Schema.define(:version => 20140129163132) do

  create_table "categories", :force => true do |t|
    t.string   "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["category"], :name => "index_categories_on_category", :unique => true

  create_table "feed_categories", :force => true do |t|
    t.integer  "category_id"
    t.integer  "feed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "feed_categories", ["category_id", "feed_id"], :name => "index_feed_categories_on_category_id_and_feed_id", :unique => true

  create_table "feed_entries", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.text     "summary"
    t.text     "content"
    t.datetime "published_at"
    t.text     "guid",         :limit => 255
    t.integer  "feed_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "feed_entries", ["feed_id"], :name => "index_feed_entries_on_feed_id"
  add_index "feed_entries", ["guid"], :name => "index_feed_entries_on_guid"

  create_table "feed_entry_categories", :force => true do |t|
    t.integer  "category_id"
    t.integer  "feed_entry_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "feed_entry_categories", ["category_id", "feed_entry_id"], :name => "index_feed_entry_categories_on_category_id_and_feed_entry_id", :unique => true

  create_table "feed_errors", :force => true do |t|
    t.string   "url"
    t.string   "error"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "trace"
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "title"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "feed_url"
    t.string   "etag"
    t.datetime "last_modified"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "feeds", ["feed_url"], :name => "index_feeds_on_feed_url", :unique => true

  create_table "layouts", :force => true do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "layouts", ["name"], :name => "index_layouts_on_name", :unique => true

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "stylesheet"
  end

  add_index "themes", ["name"], :name => "index_themes_on_name", :unique => true

  create_table "user_feed_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_entry_id"
    t.boolean  "visited",          :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "viewed",           :default => false
    t.boolean  "marked_as_viewed", :default => false
  end

  add_index "user_feed_entries", ["user_id", "feed_entry_id"], :name => "index_user_feed_entries_on_user_id_and_feed_entry_id", :unique => true

  create_table "user_feeds", :force => true do |t|
    t.integer  "feed_id"
    t.integer  "user_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "entries",    :default => 5
    t.integer  "column",     :default => 0
    t.integer  "row",        :default => 0
  end

  add_index "user_feeds", ["user_id", "feed_id"], :name => "index_user_feeds_on_user_id_and_feed_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "cookie_token"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "theme_id"
    t.integer  "layout_id"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "welcome_stage",          :default => 1
  end

  add_index "users", ["cookie_token"], :name => "index_users_on_cookie_token"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
