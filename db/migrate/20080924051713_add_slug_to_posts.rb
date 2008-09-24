class AddSlugToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :slug, :string, :null => false
    add_index :posts, :slug, :unique => true
  end

  def self.down
    remove_column :posts, :slug
  end
end
