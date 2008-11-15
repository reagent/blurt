require File.dirname(__FILE__) + '/../test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  context "An instance of the Configuration::Application class" do
    
    should "have a :base_url without a port when none is provided" do
      configuration = Configuration::Application.new('host' => 'localhost')
      assert_equal 'http://localhost/', configuration.base_url
    end
    
    should "have a :base_url with a port when one is provided" do
      configuration = Configuration::Application.new('host' => 'localhost', 'port' => 3000)
      assert_equal 'http://localhost:3000/', configuration.base_url
    end
    
    should "have a :base_url without a port when it is equal to 80" do
      configuration = Configuration::Application.new('host' => 'localhost', 'port' => 80)
      assert_equal 'http://localhost/', configuration.base_url
    end
    
    should "have a :theme accessor" do
      configuration = Configuration::Application.new('host' => 'localhost', 'theme' => 'default')
      assert_equal 'default', configuration.theme
    end
    
  end
  
  context "An instance of the Configuration::Authentication class" do
    
    setup do
      @username = 'reagent'
      @password = 'fluffybunnies'
      
      @configuration = Configuration::Authentication.new('username' => @username, 'password' => @password)
    end
    
    should "have a :username" do
      assert_equal @username, @configuration.username
    end
    
    should "have a :password" do
      assert_equal @password, @configuration.password
    end
    
  end
  
  context "The Configuration class" do
    
    setup do
      Configuration.instance_variable_set(:@configuration, nil)
      @config_file = '/path/to/configuration.yml'
    end
    
    should "load configuration data from a file" do
      YAML.expects(:load_file).with(@config_file)
      Configuration.from_file @config_file
    end
    
    should "only load the configuration data once" do
      YAML.expects(:load_file).with(@config_file).once.returns({:sample => 'config'})
      2.times { Configuration.from_file @config_file }
    end
    
    context "with loaded configuration data" do
      setup do 
        @application_configuration    = {'host' => 'localhost', 'port' => '3000'}
        @authentication_configuration = {'username' => 'reagent', 'password' => 'fluffybunnies'}

        configuration = {'application' => @application_configuration, 'authentication' => @authentication_configuration}
        Configuration.instance_variable_set(:@configuration, configuration)
      end
    
      should "contain an instance of the application configuration" do
        Configuration::Application.expects(:new).with(@application_configuration)
        Configuration.application
      end
    
      should "contain an instance of the authentication configuration" do
        Configuration::Authentication.expects(:new).with(@authentication_configuration)
        Configuration.authentication
      end
      
    end
  end
  
  
end