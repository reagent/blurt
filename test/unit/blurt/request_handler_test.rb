require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module Blurt
  class RequestHandlerTest < ActiveSupport::TestCase

    def load_service_fixture(name)
      fixture_path = File.dirname(__FILE__) + '/../../fixtures/service'
      File.read("#{fixture_path}/#{name}.xml")
    end

    context "An instance of the RequestHandler class" do
      subject { @subject ||= RequestHandler.new(stub()) }
      
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
        subject.stubs(:to_struct).with().returns(['metaWeblog.newPost', []])
        assert_equal 'metaWeblog.newPost', subject.method_name
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
        subject.stubs(:method_name).with().returns('metaWeblog.newPost')
        subject.stubs(:parameters).with().returns(['one', 'two'])
        
        Blurt::Service.expects(:call).with('metaWeblog.newPost', 'one', 'two').returns('service_response')

        XMLRPC::Marshal.expects(:dump_response).with('service_response').returns('response')
        
        assert_equal 'response', subject.response        
      end
    
    end

  end
end