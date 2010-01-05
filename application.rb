require 'rubygems'
require 'sinatra/base'

require 'fileutils'

require 'BlueCloth'
require 'hpricot'

require 'activerecord'
require 'activesupport'

require 'xmlrpc/marshal'

gem 'coderay', '= 0.7.4.215'
require 'coderay'

require 'lib/formatter/code'
require 'lib/core_ext/nil_class'
require 'lib/core_ext/string'
require 'lib/sluggable'
require 'lib/blurt'
require 'lib/blurt/request_handler'
require 'lib/blurt/service'
require 'lib/blurt/configuration'
require 'lib/blurt/theme'
require 'lib/blurt/helpers/url_helper'
require 'lib/title'


require 'models/tag'
require 'models/tagging'
require 'models/media'
require 'models/paginated_post'
require 'models/post'
require 'models/sitemap'

ActiveRecord::Base.establish_connection('adapter' => 'mysql', 'database' => 'blurt_development', 'username' => 'root', 'password' => '')

# Example blog configuration.  Copy this file to config/blurt_setup.rb
#
Blurt.setup do |config|

  # The name of your blog
  config.name        = 'my sweet blog'
  
  # The tagline for your blog
  config.tagline     = 'the mundane details of my meaningless existence'
  
  # The theme that your blog will use.  This can either be a name (e.g. 'my_theme')
  # or a full path to a theme on the filesystem.  If just a name is supplied, the 
  # configuration will look in app/themes/<theme_name>
  #
  # config.theme       = :default
  # config.theme       = '/Users/me/themes/blog_theme'
  
  # The number of posts to display per page
  config.per_page    = 20
  
  # The URL for this blog - this will be used to generate permalinks
  config.url         = 'http://localhost:4567/'
  
  # config.upload_dir = 'uploads'
  
  # The username / password to post to this blog
  config.credentials = 'user:asdf'
end

module Blurt
  class Application < Sinatra::Base

    enable :static
    set :views, Blurt.view_path
    set :public, Blurt.asset_path

    def title
      @title ||= Title.new
    end

    include Blurt::Helpers::UrlHelper

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

      def link_to(content, url)
        "<a href=\"#{url}\">#{h(content)}</a>"
      end
    end

    get '/uploads/*' do |path_to_file|
      full_path          = "#{Blurt.configuration.upload_path}/#{path_to_file}"
      send_file full_path, :disposition => nil
    end

    get '/feed' do
      content_type 'application/xml'

      @posts = Post.for_page(1)
      builder :posts
    end

    get '/sitemap.xml' do
      content_type 'text/xml'

      sitemap = Sitemap.new
      sitemap.to_xml
    end

    get '/tags' do
      title.prepend 'tags'
      @tags = Tag.by_name
      erb :tags
    end

    get '/tag/:slug' do
      @tag = Tag.find_by_slug(params[:slug])
      redirect '/tags' unless @tag

      title.prepend 'tags', @tag.name
      erb :tag
    end

    get '/page/:page' do
      title.append Blurt.configuration.tagline
      @posts = Post.for_page(params[:page])
      erb :posts
    end

    get '/' do
      title.append Blurt.configuration.tagline
      @posts = Post.for_page(1)
      erb :posts
    end

    post '/admin' do
      content_type 'text/xml'

      handler = Blurt::RequestHandler.new(request.body.read)
      handler.response
    end

    get '/:slug' do
      @post = Post.find_by_slug(params[:slug])
      redirect '/' unless @post

      title.prepend @post.title
      erb :post
    end
  end
end