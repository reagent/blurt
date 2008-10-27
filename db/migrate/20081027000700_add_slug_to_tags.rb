class AddSlugToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :slug, :string, :limit => 32, :null => false
    Tag.reset_column_information
    
    Tag.all.each {|tag| tag.update_attribute(:slug, tag.name.sluggify) }
    
    add_index :tags, :slug, :unique => true
  end

  def self.down
    remove_column :tags, :slug
  end
end
