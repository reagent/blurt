require File.dirname(__FILE__) + '/../test_helper'

class AuthenticatorTest < ActiveSupport::TestCase

  context "The Authenticator class" do

    setup do
      @username = 'reagent'
      @password = 'fluffybunnies'

      @configuration_file = "#{RAILS_ROOT}/config/sneaq.yml"
      @configuration_data = {'username' => @username, 'password' => @password}
    end

    should "know the location of the configuration file" do
      assert_equal @configuration_file, Authenticator.configuration_file
    end

    should "read the contents of the configuration file" do
      File.stubs(:exist?).with(@configuration_file).returns(true)
      YAML.stubs(:load_file).with(@configuration_file).returns(@configuration_data)

      assert_equal @configuration_data, Authenticator.configuration
    end

    should "return nil if the configuration file cannot be read" do
      File.stubs(:exist?).with(@configuration_file).returns(false)
      assert_nil Authenticator.configuration
    end

    context "with valid configuration data" do

      setup { Authenticator.stubs(:configuration).returns(@configuration_data) }

      should "authenticate a user given a valid username and password" do
        assert_equal true, Authenticator.authenticated?(@username, @password)
      end

      should "not authenticate a user with an invalid password" do
        assert_equal false, Authenticator.authenticated?(@username, @password * 2)
      end

      should "execute a block when the user is authenticated" do
        String.expects(:to_s).once
        Authenticator.with_authentication(@username, @password) do
          String.to_s
        end
      end

      should "not execute a block if the user is not authenticated" do
        String.expects(:to_s).never
        Authenticator.with_authentication(@username, @password * 2) do
          String.to_s
        end
      end

    end

    context "without configuration data" do

      setup { Authenticator.stubs(:configuration).returns(nil) }
      
      should "not authenticate a user if there is no configuration data" do
        assert_equal false, Authenticator.authenticated?(@username, @password)
      end
      
    end

  end



end