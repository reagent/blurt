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

ActiveRecord::Schema.define(:version => 20080924051713) do

  create_table "posts", :force => true do |t|
    t.string   "title",      :null => false
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",       :null => false
  end

  add_index "posts", ["slug"], :name => "index_posts_on_slug", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "post_id",    :null => false
    t.integer  "tag_id",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "taggings", ["post_id", "tag_id"], :name => "index_taggings_on_post_id_and_tag_id", :unique => true
  add_index "taggings", ["tag_id"], :name => "fk_taggings_tag_id_tags_id"

  create_table "tags", :force => true do |t|
    t.string   "name",       :limit => 32, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

end
