require File.dirname(__FILE__) + '/../../test_helper'
require 'test_fs'

module Blurt
  class ConfigurationTest < ActiveSupport::TestCase

    context "An instance of the Configuration class" do
      
      setup do
        @root_path = '/root'
        @configuration = Configuration.new(@root_path)
      end
      
      should "have an accessor for :name" do
        @configuration.name = 'foo'
        assert_equal 'foo', @configuration.name
      end
      
      should "have an accessor for :tagline" do
        @configuration.name = 'foo'
        assert_equal 'foo', @configuration.name
      end
      
      should "be able to set its theme" do
        theme = stub()
        
        Theme.expects(:new).with(:name, @root_path).returns(theme)
        @configuration.theme = :name
        assert_equal theme, @configuration.theme
      end
      
      should "generate a URI on assignment" do
        url = 'http://example.com'
        uri = stub()
        
        URI.expects(:parse).with(url).returns(uri)
        @configuration.url = url
        
        assert_equal uri, @configuration.url
      end
      
      should "be able to generate the options to pass to UrlWriter" do
        @configuration.url = 'http://localhost:3000'
        
        expected = {:protocol => 'http', :host => 'localhost', :port => 3000}
        
        assert_equal expected, @configuration.options_for_url_writer
      end
      
      should "omit the port from the urlwriter options if it is standard" do
        @configuration.url = 'http://sneaq.net:80'
        expected = {:protocol => 'http', :host => 'sneaq.net'}
        
        assert_equal expected, @configuration.options_for_url_writer
      end
      
      should "be able to assign credentials" do
        @configuration.credentials = "username:password"
        
        assert_equal 'username', @configuration.username
        assert_equal 'password', @configuration.password
      end
      
      should "know the full upload path" do
        @configuration.expects(:public_path).with().returns('/root/public')
        @configuration.upload_dir = 'uploads'
        
        assert_equal '/root/public/uploads', @configuration.upload_dir
      end
      
      should "know the public path" do
        assert_equal "#{@root_path}/public", @configuration.public_path
      end
      
      context "with a directory structure" do
        setup do
          @upload_dir = 'uploads'

          @fs = TestFs::RootDirectory.new

          @fs.dir 'public' do |p|
            p.dir @upload_dir
            p.file '404.html'
          end

          @fs.dir 'app' do |a|
            a.dir 'themes' do |t|
              t.dir 'my_theme' do |mt|
                mt.dir 'assets' do |at|
                  at.dir 'javascripts'
                  at.dir 'images' do |i|
                    i.file 'me.jpg'
                  end
                end
              end
            end
          end

          @fs.create!
          @configuration = Configuration.new(@fs.path)
        end

        teardown { @fs.destroy! }

        context "when moving asset files" do
          setup do 
            @configuration.theme      = :my_theme
            @configuration.upload_dir = @upload_dir
            
            @configuration.send(:move_asset_files!)
          end
          
          should "destroy the contents of the public directory" do
            assert_equal false, File.exist?("#{@fs.path}/public/404.html")
          end

          should "keep the upload directory intact" do
            assert_equal true, File.exist?("#{@fs.path}/public/#{@upload_dir}")
          end

          should "move the files in the assets directory to the public directory" do
            assert_equal true, File.exist?("#{@fs.path}/public/javascripts")
            assert_equal true, File.exist?("#{@fs.path}/public/images/me.jpg")
          end
        end

      end
      
    end
    
  end
end