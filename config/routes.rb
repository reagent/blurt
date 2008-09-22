ActionController::Routing::Routes.draw do |map|

  map.feed 'feed', :controller => 'posts', :action => 'index', :format => :rss

  map.root :controller => 'posts'

  # MetaWeblog API-enabled admin section
  map.admin 'admin', :controller => 'api', :action => 'api'

end
