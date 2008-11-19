class Tag < ActiveRecord::Base
  
  extend Sluggable::ClassMethods
  include Sluggable::InstanceMethods
  
  slug_column :name
  
  validates_presence_of :name
  validates_uniqueness_of :slug
  
  has_many :taggings
  has_many :posts, :through => :taggings, :order => 'posts.created_at DESC'
  
  before_validation :generate_slug
  
  named_scope :by_name, :order => 'tags.name ASC'
end