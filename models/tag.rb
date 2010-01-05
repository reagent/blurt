class Tag < ActiveRecord::Base
  
  include Sluggable
  include Blurt::Helpers::UrlHelper
  
  slug_column :name
  
  validates_presence_of :name
  validates_uniqueness_of :slug
  
  has_many :taggings
  has_many :posts, :through => :taggings, :order => 'posts.created_at DESC'
  
  before_validation :generate_slug
  
  named_scope :by_name, :order => 'tags.name ASC'
  
  def permalink
    tag_url(self)
  end
  
  def to_struct
    {
      :description => name,
      :htmlUrl     => '',
      :rssUrl      => ''
    }
  end

  
end