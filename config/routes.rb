ActionController::Routing::Routes.draw do |map|

  map.formatted_posts 'posts.:format', :controller => 'posts', :action => 'index'

  map.root :controller => 'posts'

  # MetaWeblog API-enabled admin section
  map.admin 'admin', :controller => 'api', :action => 'api'

end
