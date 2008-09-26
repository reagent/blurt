require File.dirname(__FILE__) + '/../test_helper'

class AuthenticatorTest < ActiveSupport::TestCase

  context "The Authenticator class" do

    setup do
      @username = 'reagent'
      @password = 'fluffybunnies'
    end

    context "with valid configuration data" do

      setup do
        Configuration.stubs(:authentication).returns(stub(:username => @username, :password => @password))
      end

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

  end



end