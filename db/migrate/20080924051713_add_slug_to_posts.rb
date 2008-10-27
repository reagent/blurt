class AddSlugToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :slug, :string, :null => false
    
    Post.reset_column_information
    Post.all.each {|post| post.update_attribute(:slug, post.title.sluggify)}
    
    add_index :posts, :slug, :unique => true
  end

  def self.down
    remove_column :posts, :slug
  end
end
