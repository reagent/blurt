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
      
      should "have an accessor for :upload_dir" do
        @configuration.upload_dir = 'uploads'
        assert_equal 'uploads', @configuration.upload_dir
      end
      
      should "have a default theme" do
        assert_equal 'default', @configuration.theme.name
        assert_equal "#{@root_path}/app/themes/default", @configuration.theme.path
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
        
        assert_equal '/root/public/uploads', @configuration.upload_path
      end
      
      should "not have an :upload_path if :upload_dir is not set" do
        assert_nil @configuration.upload_path
      end
      
      should "know the public path" do
        assert_equal "#{@root_path}/public", @configuration.public_path
      end
      
      should "be able to create the upload directory" do
        @configuration.upload_dir = 'uploads'
        FileUtils.expects(:mkdir).with(@configuration.upload_path)
        
        @configuration.create_upload_directory!
      end
      
      should "not create the upload directory if it exists" do
        @configuration.upload_dir = 'uploads'
        
        File.expects(:exist?).with(@configuration.upload_path).returns(true)
        FileUtils.expects(:mkdir).with(@configuration.upload_path).never
        
        @configuration.create_upload_directory!
      end
      
      should "not create a directory if the upload path is not set" do
        FileUtils.expects(:mkdir).never
        @configuration.create_upload_directory!
      end
      
      context "with a directory structure" do
        setup do
          @upload_dir = 'uploads'

          @fs = setup_filesystem do |root|
            root.dir 'public' do |public|
              public.dir @upload_dir
              public.file '404.html'
              public.file '.hidden'
            end
            
            root.dir 'app' do |app|
              app.dir 'themes' do |themes|
                themes.dir 'my_theme' do |theme|
                  theme.dir 'assets' do |assets|
                    assets.dir 'javascripts'
                    assets.dir 'images' do |images|
                      images.file 'me.jpg'
                    end
                  end
                end
              end
            end
          end

          @configuration = Configuration.new(@fs.path)
        end

        teardown { @fs.destroy! }

        should "have a list of public files" do
          expected = %w(404.html uploads).map {|f| "#{@fs.path}/public/#{f}" }
          assert_equal expected, @configuration.public_files
        end
        
        should "ignore the upload dir when retrieving the list of public files" do
          expected = [ "#{@fs.path}/public/404.html" ]
          @configuration.upload_dir = 'uploads'
          
          assert_equal expected, @configuration.public_files
        end
        
        should "have a list of asset files" do
          expected = %w(javascripts images).inject({}) do |result, f|
            result.merge("#{@fs.path}/app/themes/my_theme/assets/#{f}" => f)
          end
          
          @configuration.theme      = :my_theme
          assert_equal expected, @configuration.asset_files
        end

        context "when preparing the public directory" do
          setup do 
            @configuration.theme      = :my_theme
            @configuration.upload_dir = @upload_dir
          end
          
          should "create the upload directory" do
            @configuration.expects(:create_upload_directory!)
            @configuration.prepare_public_directory!
          end
          
          should "destroy the contents of the public directory" do
            @configuration.prepare_public_directory!
            assert_equal false, File.exist?("#{@fs.path}/public/404.html")
          end

          should "keep the upload directory intact" do
            @configuration.prepare_public_directory!
            assert_equal true, File.exist?("#{@fs.path}/public/#{@upload_dir}")
          end

          should "move the files in the assets directory to the public directory" do
            @configuration.prepare_public_directory!
            assert_equal true, File.exist?("#{@fs.path}/public/javascripts")
            assert_equal true, File.exist?("#{@fs.path}/public/images/me.jpg")
          end
        end

      end
      
    end
    
  end
end