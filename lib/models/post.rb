class Post < ActiveRecord::Base
  
  include Sluggable
  include Blurt::Helpers::UrlHelper
  
  slug_column :title
  
  validates_presence_of :title, :body
  
  has_many :taggings
  has_many :tags, :through => :taggings
  
  named_scope :by_date, :order => 'created_at DESC', :include => :tags
  named_scope :with_limit, lambda {|limit| {:limit => limit} }
  
  before_validation :generate_slug
  after_save :save_tags

  def self.per_page
    Blurt.configuration.per_page
  end
  
  def self.page_count
    (self.count == 0) ? 1 : (self.count.to_f / self.per_page).ceil
  end
  
  def self.for_page(page_number)
    page_number = 1 if page_number.blank?
    PaginatedPost.new(:page => page_number)
  end

  def tag_names=(tag_names)
    @tag_names = (tag_names || []).uniq
  end
  
  def tag_names
    @tag_names ||= self.tags.map(&:name)
  end

  def content
    Blurt::Formatter.new(self.body)
  end
  
  def permalink
    post_url(self)
  end
  
  def to_rss
    xml = Builder::XmlMarkup.new(:indent => 2, :margin => 2)
    xml.item do
      xml.title title
      xml.description content.to_html
      xml.pubDate created_at.to_s(:rfc822)
      xml.link permalink
      xml.guid permalink
    end
    xml.target!
  end
  
  def reload(options = {})
    @tag_names = nil
    super(options)
  end

  private
  def save_tags
    self.tags = self.tag_names.map {|tag_name| Tag.find_or_create_by_name(tag_name) }
  end
  
end
