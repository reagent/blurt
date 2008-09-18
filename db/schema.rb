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

ActiveRecord::Schema.define(:version => 20080918031328) do

  create_table "posts", :force => true do |t|
    t.string   "title",      :null => false
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "post_id",    :limit => 11, :null => false
    t.integer  "tag_id",     :limit => 11, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "taggings", ["post_id"], :name => "fk_taggings_post_id_posts_id"
  add_index "taggings", ["tag_id"], :name => "fk_taggings_tag_id_tags_id"

  create_table "tags", :force => true do |t|
    t.string   "name",       :limit => 32, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

end
