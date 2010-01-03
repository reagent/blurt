class Tagging < ActiveRecord::Base
  
  validates_presence_of :tag_id, :post_id
  validates_uniqueness_of :tag_id, :scope => :post_id
  
  belongs_to :post
  belongs_to :tag
  
end
