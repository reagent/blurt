class Sitemap
  
  include ActionController::UrlWriter
  
  def root
    @root ||= Element.new(:location => root_url, :modified_at => ::Post.maximum(:updated_at))
  end

  def pages
    @pages ||= (2..::Post.page_count).map {|i| Page.new(i) }
  end
  
  def posts
    @posts ||= ::Post.by_date.map {|p| Post.new(p) }
  end
  
  def tag_list
    @tag_list ||= Element.new(:location => tags_url, :modified_at => ::Tag.maximum(:updated_at))
  end
  
  def tags
    @tags ||= ::Tag.all.map {|t| Tag.new(t) }
  end
  
  def xml
    @xml ||= Builder::XmlMarkup.new(:indent => 2)    
  end
  
  def to_xml
    xml.instruct! :xml, :version => "1.0" 
    xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
      xml << self.root.to_xml
      xml << self.pages.map(&:to_xml).join
      xml << self.posts.map(&:to_xml).join
      xml << self.tag_list.to_xml
      xml << self.tags.map(&:to_xml).join
    end
    
    xml.target!
  end
  
  # == Element
  # Represents a node in the sitemap
  #
  class Element
    
    def initialize(options = {})
      @options = options
    end
    
    def location
      @location ||= @options[:location]
    end
    
    def modified_on
      @modified_on ||= (@options[:modified_at] || Time.now).strftime('%Y-%m-%d')
    end
    
    def change_frequency
      'daily'
    end
    
    def priority
      '0.8'
    end
    
    def xml
      @xml ||= Builder::XmlMarkup.new(:indent => 2, :margin => 1)
    end
    
    def to_xml
      @to_xml ||= begin 
        xml.url do 
          xml.loc self.location
          xml.lastmod self.modified_on
          xml.changefreq self.change_frequency
          xml.priority self.priority
        end

        xml.target!
      end
    end
  end
  
  # == Post
  # A node that represents a post entry
  #
  class Post < Element
    
    def initialize(post)
      super :location => post.permalink, :modified_at => post.updated_at
    end

    def change_frequency
      'monthly'
    end
    
    def priority
      '0.5'
    end
        
  end
  
  # == Page
  # Represents an individual page
  #
  class Page < Element
   
    include ActionController::UrlWriter
    
    def initialize(page_number)
      super :location => posts_url(page_number), 
            :modified_at => ::Post.maximum(:updated_at)
    end
    
  end
  
  # == Tag
  # Represents an individual tag
  #
  class Tag < Element
    
    include ActionController::UrlWriter
    
    def initialize(tag)
      super :location => tag_url(tag), :modified_at => tag.updated_at
    end
    
    def change_frequency
      'monthly'
    end
    
    def priority
      '0.5'
    end
    
  end
  
end