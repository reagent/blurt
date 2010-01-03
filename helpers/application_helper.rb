# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def tag_links_for(post, html_options = {})
    post.tags.map {|tag| link_to tag.name, tag_path(tag), html_options }.join(', ')
  end
  
  def link_to_next_page(paginated_post)
    link_to('Next Page >>', posts_path(paginated_post.next_page)) if paginated_post.next_page?
  end
  
  def link_to_previous_page(paginated_post)
    link_to('<< Previous Page', posts_path(paginated_post.previous_page)) if paginated_post.previous_page?
  end
end
