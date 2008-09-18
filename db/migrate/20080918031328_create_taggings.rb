class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.integer :post_id, :tag_id, :null => false
      t.datetime :created_at, :updated_at, :null => false
    end
    
    add_index :taggings, [:post_id, :tag_id], :unique => true
    
    execute "
      ALTER TABLE `taggings`
      ADD CONSTRAINT `fk_taggings_post_id_posts_id`
      FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) "
    
    execute "
      ALTER TABLE `taggings`
      ADD CONSTRAINT `fk_taggings_tag_id_tags_id`
      FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) "
    
  end

  def self.down
    drop_table :taggings
  end
end
