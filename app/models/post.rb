class Post < ActiveRecord::Base
  
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
  
  def self.others_by_slug(id, slug)
    conditions = id.nil? ? {} : {:conditions => ['id != ?', id]}
    find_by_slug(slug, conditions)
  end
  
  def tag_names
    @tag_names ||= self.tags.map(&:name)
    @tag_names.uniq!
    @tag_names
  end

  def to_param; self.slug; end
  
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
  
  def sluggify(title)
    slug = nil
    slug = title.sluggify unless title.nil?
    slug
  end
  
  def next_available_slug(base_slug)
    valid_slug = base_slug
    
    index = 2
    while Post.others_by_slug(self.id, valid_slug)
      valid_slug = base_slug + "-#{index}"
      index+= 1
    end
    valid_slug
  end
  
  def generate_slug
    self.slug = next_available_slug(sluggify(self.title))
  end
  
end
