class Post < ActiveRecord::Base
  
  extend Sluggable::ClassMethods
  include Sluggable::InstanceMethods
  
  slug_column :title
  
  validates_presence_of :title, :body
  
  has_many :taggings
  has_many :tags, :through => :taggings do
    def to_s
      self.map(&:name).join(', ')
    end
  end
  
  named_scope :by_date, :order => 'created_at DESC'
  named_scope :with_limit, lambda {|limit| {:limit => limit} }
  
  attr_accessor :tag_names
  
  before_validation :generate_slug
  after_save :save_tags
  
  def tag_names
    @tag_names ||= self.tags.map(&:name)
    @tag_names.uniq!
    @tag_names
  end

  def content
    Formatter::Code.new(self.body)
  end
  
  def permalink
    "#{Configuration.application.base_url}#{self.slug}"
  end
  
  private
  def save_tags
    self.tags = self.tag_names.map {|tag_name| Tag.find_or_create_by_name(tag_name) }
  end
  
end
