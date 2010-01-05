require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

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
      
      should "have a default upload directory" do
        assert_equal 'uploads', @configuration.upload_dir
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
      
      should "remove trailing slashes from URL on assignment" do
        @configuration.url = 'http://foo.com:1234/'
        assert_equal 'http://foo.com:1234', @configuration.url
      end
      
      should "be able to assign credentials" do
        @configuration.credentials = "username:password"
        
        assert_equal 'username', @configuration.username
        assert_equal 'password', @configuration.password
      end
      
      should "know the full upload path" do
        @configuration.upload_dir = 'uploads'
        
        assert_equal '/root/uploads', @configuration.upload_path
      end
      
      should "be able to create the upload directory" do
        @configuration.upload_dir = 'uploads'
        FileUtils.expects(:mkdir).with(@configuration.upload_path)
        
        @configuration.create_upload_directory
      end
      
      should "not create the upload directory if it exists" do
        @configuration.upload_dir = 'uploads'
        
        File.expects(:exist?).with(@configuration.upload_path).returns(true)
        FileUtils.expects(:mkdir).with(@configuration.upload_path).never
        
        @configuration.create_upload_directory
      end
      
    end
    
  end
end