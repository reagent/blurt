class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title, :null => false
      t.text :body, :null => false
      t.datetime :created_at, :updated_at, :nil => false
    end
  end

  def self.down
    drop_table :posts
  end
end
