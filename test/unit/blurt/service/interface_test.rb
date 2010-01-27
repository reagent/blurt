require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class BasicInterfaceImplementation
  include Blurt::Service::Interface
  def newPost; end  
end

class AdvancedInterfaceImplementation
  include Blurt::Service::Interface
  
  skip_authentication_for :getCategories, :getSupportedFilters
  
  def getCategories; end
  def getSupportedFilters; end
end

module Blurt
  module Service
    class InterfaceTest < ActiveSupport::TestCase
    
      context "The AdvancedInterfaceImplementation class" do
        
        should "know the public entry points" do
          assert_equal [:getCategories, :getSupportedFilters], AdvancedInterfaceImplementation.public_entry_points
        end
        
      end
      
      context "An instance of the AdvancedInterfaceImplementation class" do
        should "know that it needs to authenticate a method call" do
          service = AdvancedInterfaceImplementation.new('newPost')
          assert_equal true, service.authenticate?
        end
        
        should "know that it doesn't need to authenticate a method call" do
          service = AdvancedInterfaceImplementation.new('getCategories')
          assert_equal false, service.authenticate?
        end
        
        should "be able to dispatch to the appropriate method without authentication" do
          service = AdvancedInterfaceImplementation.new('getCategories')
          
          service.stubs(:parameters).with().returns(['one', 'two'])
          service.expects(:authenticate).never
          service.expects(:getCategories).with('one', 'two').returns('category')
          
          assert_equal 'category', service.call
        end
      end
      
      context "The BasicInterfaceImplementation class" do
        
        should "have no public entry points" do
          assert_equal [], BasicInterfaceImplementation.public_entry_points
        end
        
      end
    
      context "An instance of the BasicInterfaceImplementation class" do
        
        should "be able to extract the username and password from the parameters" do
          service = BasicInterfaceImplementation.new('newPost', '0', 'username', 'password', 'other')
          username, password = service.extract_credentials
        
          assert_equal 'username', username
          assert_equal 'password', password
        
          assert_equal ['0', 'other'], service.parameters
        end
      
        should "raise an exception when attempting to authenticate a user whose credentials are incorrect" do
          Blurt.stubs(:configuration).with().returns(stub(:username => 'admin', :password => 'secret'))
        
          service = BasicInterfaceImplementation.new('newPost', '0', 'username', 'password')
          assert_raises(Blurt::Service::AuthenticationError) { service.authenticate }
        end
      
        should "not raise an exception when attempting to authenticate a user with matching credentials" do
          Blurt.stubs(:configuration).with().returns(stub(:username => 'username', :password => 'password'))
        
          service = BasicInterfaceImplementation.new('newPost', '0', 'username', 'password')
          assert_nothing_raised { service.authenticate }
        end
      
        should "be able to dispatch to the appropriate method with authentication" do
          service = BasicInterfaceImplementation.new('newPost', '0', 'username', 'password', {'title' => 'foo'}, true)
          service.stubs(:parameters).with().returns(['one', 'two'])
          service.expects(:authenticate).with()

          service.expects(:newPost).with('one', 'two').returns('1')
        
          assert_equal '1', service.call
        end
        
      end
    
    end
  end
end