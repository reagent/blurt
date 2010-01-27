require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class ServiceImplementation
  include Blurt::Service
  
  def newPost; end
end

module Blurt
  class ServiceTest < ActiveSupport::TestCase
    
    context "The implementation of the Service module" do
      
      should "be able to extract the username and password from the parameters" do
        service = ServiceImplementation.new('newPost', '0', 'username', 'password', 'other')
        username, password = service.extract_credentials
        
        assert_equal 'username', username
        assert_equal 'password', password
        
        assert_equal ['0', 'other'], service.parameters
      end
      
      should "raise an exception when attempting to authenticate a user whose credentials are incorrect" do
        Blurt.stubs(:configuration).with().returns(stub(:username => 'admin', :password => 'secret'))
        
        service = ServiceImplementation.new('newPost')
        assert_raises(Blurt::Service::AuthenticationError) do
          service.authenticate('username', 'password')
        end
      end
      
      should "not raise an exception when attempting to authenticate a user with matching credentials" do
        Blurt.stubs(:configuration).with().returns(stub(:username => 'username', :password => 'password'))
        
        service = ServiceImplementation.new('newPost')
        assert_nothing_raised { service.authenticate('username', 'password') }
      end
      
      
      should "be able to dispatch to the appropriate method with authentication" do
        service = ServiceImplementation.new('newPost', '0', 'username', 'password', {'title' => 'foo'}, true)
        service.expects(:authenticate).with('username', 'password')
        service.expects(:newPost).with('0', {'title' => 'foo'}, true).returns('1')
        
        assert_equal '1', service.call
      end
      
    end
    
  end
end