require 'sinatra/base'
require 'lib/blurt'

begin
  require 'config/setup.rb'
rescue LoadError
  puts "Please create the file config/setup.rb (see the example file)"
  exit 1
end

module Blurt
  class Application < Sinatra::Base

    include Blurt::Helpers::LinkHelper

    enable :static
    set :views, Blurt.view_path
    set :public, Blurt.asset_path

    def title
      @title ||= Title.new
    end

    get '/uploads/*' do |path_to_file|
      full_path          = "#{Blurt.configuration.upload_path}/#{path_to_file}"
      send_file full_path, :disposition => nil
    end

    get '/feed' do
      content_type 'application/xml'

      @posts = Post.for_page(1).to_rss
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