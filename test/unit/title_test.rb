require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class TitleTest < ActiveSupport::TestCase
  
  context "An instance of the Title class" do
    
    setup do
      @name = 'blurt.'
      Blurt.expects(:configuration).returns(stub(:name => @name))
    end
    
    should "have a default value" do
      title = Title.new
      assert_equal @name, title.to_s
    end
    
    should "be able to prepend to the title" do
      title = Title.new
      title.prepend('A post')
      assert_equal "A post | #{@name}", title.to_s
    end
    
    should "be able to prepend multiple contents to the title" do
      title = Title.new
      title.prepend 'one', 'two'
      assert_equal "two | one | #{@name}", title.to_s
    end
   
    should "not change the title when prepending a nil value" do
      title = Title.new
      title.prepend nil
      
      assert_equal @name, title.to_s
    end
    
    should "be able to append to the title" do
      title = Title.new
      title.append('tagline')
      assert_equal "#{@name} | tagline", title.to_s
    end
    
    should "be able to append multiple contents to the title" do
      title = Title.new
      title.append 'one', 'two'
      assert_equal "#{@name} | one | two", title.to_s
    end
   
    should "not change the title when appending a nil value" do
      title = Title.new
      title.append nil
      
      assert_equal @name, title.to_s
    end
    
  end
  
end