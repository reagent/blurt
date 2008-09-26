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
    self.tags.clear
    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name)
      self.tags << tag
    end
  end
  
  def generate_slug
    unless self.title.nil?
      base_slug = self.title.downcase
      base_slug.gsub!(/[^0-9a-z_ -]/, '')
      base_slug.gsub!(/\s+/, '-')
      
      attempted_slug = base_slug
      
      index = 2
      while Post.find_by_slug(attempted_slug)
        attempted_slug = base_slug + "-#{index}"
        index+= 1
      end
      
      self.slug = attempted_slug
    end
  end
  
end
