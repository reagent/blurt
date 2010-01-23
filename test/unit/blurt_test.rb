require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class BlurtTest < ActiveSupport::TestCase
  
  context "The Blurt module" do
    
    setup do
      # Clear the value in configuration (since it's memoized)
      Blurt.instance_variable_set(:@configuration, nil)
      
      @rack_env = ENV['RACK_ENV']
    end
    
    teardown { ENV['RACK_ENV'] = @rack_env }

    should "defautl the environment to 'development' if it is not set" do
      ENV['RACK_ENV'] = nil
      assert_equal 'development', Blurt.env
    end
    
    should "know the environment if it is set" do
      ENV['RACK_ENV'] = 'production'
      assert_equal 'production', Blurt.env
    end

    should "know the root directory" do
      path = File.expand_path(File.dirname(__FILE__) + '/../..')
      assert_equal path, Blurt.root.to_s
    end

    should "have a configuration reader" do
      config = stub()
      Blurt::Configuration.expects(:new).with(Blurt.root).returns(config)
      
      assert_equal config, Blurt.configuration
    end
    
    should "memoize the configuration instance" do
      Blurt::Configuration.expects(:new).with(Blurt.root).once.returns(stub())
      2.times { Blurt.configuration }
    end
    
    should "yield an instance of the Blurt::Configuration class" do
      theme_name = 'my_theme'
      theme      = stub()
      
      configuration = mock do |m|
        m.expects(:theme=).with(theme_name).returns(theme)
        m.stubs(:boot)
      end
      
      Blurt::Configuration.expects(:new).with(Blurt.root).returns(configuration)
      
      Blurt.setup {|config| config.theme = theme_name }
    end
    
    should "bootstrap the application when configuring" do
      configuration = mock do |m|
        m.expects(:boot).with()
      end
      
      Blurt::Configuration.expects(:new).with(Blurt.root).returns(configuration)
      
      Blurt.setup {|config| 'foo' }
    end
    
    should "delegate the :view_path to the configured theme" do
      theme = stub(:view_path => 'view')
      Blurt.stubs(:configuration).with().returns(stub(:theme => theme))
      
      assert_equal 'view', Blurt.view_path
    end
    
    should "delegate the :asset_path to the configured theme" do
      theme = stub(:asset_path => 'asset')
      Blurt.stubs(:configuration).with().returns(stub(:theme => theme))
      
      assert_equal 'asset', Blurt.asset_path
    end
    
  end
  
end