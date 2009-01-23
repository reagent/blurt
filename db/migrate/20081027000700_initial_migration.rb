class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title, :slug, :null => false
      t.text :body, :null => false
      t.datetime :created_at, :updated_at, :nil => false
    end

    add_index :posts, :slug, :unique => true
        
    create_table :tags do |t|
      t.string :name, :slug, :limit => 32, :null => false
      t.datetime :created_at, :updated_at, :null => false
    end

    add_index :tags, :slug, :unique => true
    
    create_table :taggings do |t|
      t.integer :post_id, :tag_id, :null => false
      t.datetime :created_at, :updated_at, :null => false
    end
    
    add_index :taggings, [:post_id, :tag_id], :unique => true
    
  end

  def self.down
    drop_table :taggings, :tags, :posts
  end
end
