class Tag < ActiveRecord::Base
  
  validates_presence_of :name
  
  has_many :taggings
  
  named_scope :by_name, :order => 'tags.name ASC'
end