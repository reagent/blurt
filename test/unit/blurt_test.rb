require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class BlurtTest < ActiveSupport::TestCase
  
  context "The Blurt module" do

    # Clear the value in configuration (since it's memoized)
    setup { Blurt.instance_variable_set(:@configuration, nil) }

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
        m.stubs(:prepare_public_directory!)
      end
      
      Blurt::Configuration.expects(:new).with(Blurt.root).returns(configuration)
      
      Blurt.setup {|config| config.theme = theme_name }
    end
    
    should "move asset files as part of setup" do
      configuration = mock do |m| 
        m.expects(:name=).with('sneaq')
        m.expects(:prepare_public_directory!).with()
      end
      
      Blurt.stubs(:configuration).with().returns(configuration)
      
      Blurt.setup {|config| config.name = 'sneaq' }
    end
    
  end
  
end