require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module Blurt
  class ServiceTest < ActiveSupport::TestCase
    
    context "The Service module" do
      setup { Service.instance_variable_set(:@namespaces, nil) }
      
      should "have no methods by default" do
        assert_equal [], Service.methods
      end
      
      should "know the current namespace" do
        definition =<<-CODE
          service :name do end
        CODE
        
        Service.load(definition)
        
        assert_equal :name, Service.current_namespace.name
      end
      
      should "be able to add a service with a method" do
        definition = <<-CODE
          service :system do
            method :echo do |message|
              message
            end
          end
        CODE
        
        Service.load(definition)
        
        assert_equal ['system.echo'], Service.methods
      end
      
      should "know the list of all defined methods" do
        definition =<<-CODE
          service :first do
            method :post do end
          end
          service :second do
            method :place do end
          end
        CODE

        Service.load(definition)
        
        assert_equal ['first.post', 'second.place'], Service.methods.sort
      end
      
      should "be able to call a defined method" do
        definition = <<-CODE
          service :system do
            method :echo do |message|
              message
            end
          end
        CODE
        
        Service.load(definition)
        
        assert_equal 'Rudy!', Service.call('system.echo', 'Rudy!')
      end
      
      should "be able to define and call a struct transformation" do
        definition = <<-CODE
          service :system do
            method :getPost do |post|
              to_struct(:post, post)
            end
            
            struct :post do |post|
              {:postId => post.id}
            end
          end
        CODE
        
        post = stub(:id => 42)
        
        Service.load(definition)
        
        expected = {:postId => 42}
        
        assert_equal expected, Service.call('system.getPost', post)
      end
      
      should "be able to load a definition from a file" do
        definition =<<-CODE
          service :system do
            method :echo do |message|
              message
            end
          end
        CODE
        
        path = '/path/to/service.rb'
        File.stubs(:read).with(path).returns(definition)
        
        Service.load_file(path)
        
        assert_equal ['system.echo'], Service.methods
        assert_equal "Rudy!", Service.call('system.echo', "Rudy!")
      end
      
      should "be able to define an authentication method" do
        Service.authentication {|username, password| true }
        assert_nothing_raised { Service.authenticate('username', 'password') }
      end
      
      should "raise an authentication error when authentication returns false" do
        Service.authentication {|username, password| false }
        assert_raises(Blurt::Service::AuthenticationError) { Service.authenticate('u', 'p') }
      end
      
      should "raise an authentication error when authentication returns a non-true value" do
        Service.authentication {|username, password| '1' }
        assert_raises(Blurt::Service::AuthenticationError) { Service.authenticate('u', 'p') }
      end

    end
    
    
  end
end