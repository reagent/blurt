require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module Blurt
  class RequestHandlerTest < ActiveSupport::TestCase

    def load_service_fixture(name)
      fixture_path = File.dirname(__FILE__) + '/../../fixtures/service'
      File.read("#{fixture_path}/#{name}.xml")
    end

    context "An instance of the Service class" do
      
      should "be able to convert an RPC call to a struct" do

        handler = RequestHandler.new(load_service_fixture('newPost'))
        
        expected = [
          'metaWeblog.newPost', 
          [
            '0', 
            'username', 
            'password', 
            {
              'mt_convert_breaks' => 'markdown_with_smartypants', 
              'title'             => 'My Title', 
              'description'       => 'My Body', 
              'categories'        => ['One', 'Two']
            },
            true
          ]
        ]
        
        assert_equal expected, handler.to_struct
      end
      
      should "know the method being called" do
        handler = RequestHandler.new(load_service_fixture('newPost'))
        assert_equal 'newPost', handler.method_name
      end
      
      should "know the parameters for the method being called" do
        handler = RequestHandler.new(load_service_fixture('newPost'))
        expected = [
          '0', 
          'username', 
          'password', 
          {
            'mt_convert_breaks' => 'markdown_with_smartypants', 
            'title'             => 'My Title', 
            'description'       => 'My Body', 
            'categories'        => ['One', 'Two']
          },
          true
        ]
        
        assert_equal expected, handler.parameters
      end
      
      should "be able to return the appropriate response" do
        handler = RequestHandler.new(load_service_fixture('newPost'))
        handler.stubs(:method_name).with().returns('newPost')
        handler.stubs(:parameters).with().returns(['one', 'two'])
        
        service_mock = mock() {|s| s.expects(:call).with().returns('service_response') }
        Service.expects(:new).with('newPost', 'one', 'two').returns(service_mock)
        
        XMLRPC::Marshal.expects(:dump_response).with('service_response').returns('response')
        
        assert_equal 'response', handler.response
      end
      
    end

  end
end