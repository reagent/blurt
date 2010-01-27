require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module Blurt
  class RequestHandlerTest < ActiveSupport::TestCase

    def load_service_fixture(name)
      fixture_path = File.dirname(__FILE__) + '/../../fixtures/service'
      File.read("#{fixture_path}/#{name}.xml")
    end

    context "An instance of the RequestHandler class" do
      
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
      
      should "know the service name" do
        handler = RequestHandler.new('')
        handler.stubs(:to_struct).with().returns(['metaWeblog.newPost', []])
        
        assert_equal 'metaWeblog', handler.service_name
      end
      
      should "know the name of the service class when handling a metaWeblog request" do
        handler = RequestHandler.new('')
        handler.stubs(:service_name).with().returns('metaWeblog')
        
        assert_equal Blurt::Service::MetaWeblog, handler.service_class
      end
      
      should "know the name of the service class when handling a movable type request" do
        handler = RequestHandler.new('')
        handler.stubs(:service_name).with().returns('mt')
        
        assert_equal Blurt::Service::MovableType, handler.service_class
      end
      
      should "know the method being called when handling a Meta Weblog request" do
        handler = RequestHandler.new('')
        handler.stubs(:to_struct).with().returns(['metaWeblog.newPost', []])
        
        assert_equal 'newPost', handler.method_name
      end
      
      should "know the method being called when handling a Movable Type request" do
        handler = RequestHandler.new('')
        handler.stubs(:to_struct).with().returns(['mt.getPostCategories', []])
        
        assert_equal 'getPostCategories', handler.method_name
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
        handler.stubs(:service_class).with().returns(Blurt::Service::MetaWeblog)
        
        service_mock = mock() {|s| s.expects(:call).with().returns('service_response') }
        Blurt::Service::MetaWeblog.expects(:new).with('newPost', 'one', 'two').returns(service_mock)
        
        XMLRPC::Marshal.expects(:dump_response).with('service_response').returns('response')
        
        assert_equal 'response', handler.response
      end
      
    end

  end
end