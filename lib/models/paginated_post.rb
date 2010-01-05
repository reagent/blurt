class PaginatedPost
  
  include Enumerable
  
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
  
end