ActionController::Routing::Routes.draw do |map|

  map.feed    'feed', :controller => 'posts', :action => 'index', :format => :rss
  map.sitemap 'sitemap.xml', :controller => 'sitemap', :action => 'show', :format => 'xml'

  map.with_options :controller => 'tags' do |tags|
    tags.tag  'tag/:slug', :action => 'show'
    tags.tags 'tags', :action => 'index'
  end

  map.posts 'page/:page', :controller => 'posts', :action => 'index'
  map.root  :controller => 'posts', :action => 'index'

  # MetaWeblog API-enabled admin section
  map.admin 'admin', :controller => 'api', :action => 'api'

  map.permalink ':id', :controller => 'posts', :action => 'show'
end
