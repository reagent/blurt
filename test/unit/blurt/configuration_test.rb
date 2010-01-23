require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module Blurt
  class ConfigurationTest < ActiveSupport::TestCase

    context "An instance of the Configuration class" do
      
      setup do
        @root_path = '/root'
        @configuration = Configuration.new(@root_path)
      end
      
      should "have an accessor for :connection" do
        @configuration.connection = 'foo'
        assert_equal 'foo', @configuration.connection
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
        assert_equal "#{@root_path}/themes/default", @configuration.theme.path
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
      
      should "know the path to the environment file that needs to be loaded" do
        Blurt.stubs(:root).with().returns('/blurt')
        Blurt.stubs(:env).with().returns('development')
        
        assert_equal '/blurt/config/setup/development.rb', @configuration.environment_file
      end
      
      should "be able to read the environment file" do
        file = Tempfile.new(self.class)
        file.write('blip')
        file.close
        
        @configuration.stubs(:environment_file).with().returns(file.path)
        
        assert_equal 'blip', @configuration.read_environment_file
      end
      
      should "return nil when reading the environment file if it does not exist" do
        file = Tempfile.new(self.class)
        file.close
        
        missing_file_path = file.path
        file.unlink
        
        @configuration.stubs(:environment_file).with().returns(missing_file_path)
        
        assert_nil @configuration.read_environment_file
      end
      
      should "be able to evaluate the environment file" do
        @configuration.name = 'original'
        @configuration.stubs(:read_environment_file).with().returns("config.name = 'new'")
        
        @configuration.load_environment
        
        assert_equal 'new', @configuration.name
      end
      
      should "not evaluate the environment file if there is no data in it" do
        @configuration.stubs(:read_environment_file).with().returns(nil)
        @configuration.expects(:eval).never
        
        @configuration.load_environment
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
      
      should "be able to connect to the database" do
        ActiveRecord::Base.expects(:establish_connection).with('foo')
        
        @configuration.connection = 'foo'
        @configuration.connect_to_database
      end
      
      should "be able to bootstrap the application" do
        @configuration.expects(:load_environment).with()
        @configuration.expects(:create_upload_directory).with()
        @configuration.expects(:connect_to_database)
        
        @configuration.boot
      end
      
    end
    
  end
end