# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def tag_links_for(post, html_options = {})
    post.tags.map {|tag| link_to tag.name, tag_path(tag), html_options }.join(', ')
  end
end
