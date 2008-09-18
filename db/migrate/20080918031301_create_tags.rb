class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name, :limit => 32, :null => false
      t.datetime :created_at, :updated_at, :null => false
    end
  end

  def self.down
    drop_table :tags
  end
end
