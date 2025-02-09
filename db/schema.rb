# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091001020258) do

  create_table "card_attributes", :force => true do |t|
    t.string  "name"
    t.integer "value"
    t.integer "card_id"
  end

  create_table "card_characteristic_connections", :force => true do |t|
    t.integer "card_id",                :null => false
    t.integer "card_characteristic_id", :null => false
  end

  create_table "card_characteristics", :force => true do |t|
    t.string "name"
  end

  create_table "card_filter_items", :force => true do |t|
    t.string  "category"
    t.string  "condition"
    t.string  "value"
    t.integer "card_filter_id", :null => false
  end

  create_table "card_filters", :force => true do |t|
    t.string  "name"
    t.integer "user_id", :null => false
  end

  create_table "cards", :force => true do |t|
    t.string   "title"
    t.string   "side"
    t.string   "lore"
    t.string   "gametext"
    t.string   "image_front_url"
    t.string   "image_back_url"
    t.string   "expansion"
    t.string   "rarity"
    t.string   "uniqueness"
    t.string   "card_type"
    t.string   "subtype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deck_items", :force => true do |t|
    t.integer  "card_id",    :null => false
    t.integer  "deck_id",    :null => false
    t.integer  "quantity",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tab"
  end

  create_table "decks", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "import_file_file_name"
    t.string   "import_file_content_type"
    t.integer  "import_file_file_size"
    t.datetime "import_file_updated_at"
    t.boolean  "shared"
    t.boolean  "locked"
  end

  create_table "post_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "post_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating_average",  :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.string   "cached_tag_list"
    t.integer  "deck_id"
  end

  create_table "rates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars"
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id"], :name => "index_rates_on_rateable_id"
  add_index "rates", ["user_id"], :name => "index_rates_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                        :limit => 40
    t.string   "email",                        :limit => 100
    t.string   "crypted_password",             :limit => 40
    t.string   "salt",                         :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",               :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",              :limit => 40
    t.datetime "activated_at"
    t.integer  "rating_average_skill",         :limit => 10,  :precision => 10, :scale => 0, :default => 0
    t.integer  "rating_average_sportsmanship", :limit => 10,  :precision => 10, :scale => 0, :default => 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
    t.string   "blog_title"
    t.text     "about_me"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "reset_password_token"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
