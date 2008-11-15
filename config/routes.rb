ActionController::Routing::Routes.draw do |map|

  map.feed 'feed', :controller => 'posts', :action => 'index', :format => :rss

  map.with_options :controller => 'tags' do |tags|
    tags.tag  'tag/:slug', :action => 'show'
    tags.tags 'tags', :action => 'index'
  end

  map.root :controller => 'posts'

  # MetaWeblog API-enabled admin section
  map.admin 'admin', :controller => 'api', :action => 'api'

  map.permalink ':id', :controller => 'posts', :action => 'show'
end
