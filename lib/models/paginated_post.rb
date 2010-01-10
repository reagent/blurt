class PaginatedPost
  
  include Enumerable
  include Blurt::Helpers::UrlHelper
  
  def initialize(params)
    @current_page = params[:page].to_i
  end
  
  def current_page
    @current_page
  end
  
  def next_page?
    Post.page_count > self.current_page
  end
  
  def next_page
    next_page? ? (self.current_page + 1) : Post.page_count
  end
  
  def previous_page?
    self.current_page != 1
  end
  
  def previous_page
    previous_page? ? (self.current_page - 1) : 1
  end
  
  def conditions
    {
      :offset => (self.current_page - 1) * Post.per_page, 
      :limit  => Post.per_page
    }
  end
  
  def posts
    @posts ||= Post.by_date.find(:all, self.conditions)
  end
  
  def each(&block)
    self.posts.each(&block)
  end
  
  def to_rss
    rss = Builder::XmlMarkup.new
    rss.instruct! :xml, :version => "1.0" 
    rss.rss :version => "2.0" do
      rss.channel do
        rss.title Blurt.configuration.name
        rss.description Blurt.configuration.tagline unless Blurt.configuration.tagline.blank?
        rss.link root_url
    
        each {|post| rss << post.to_rss }
      end
    end
  end
  
end