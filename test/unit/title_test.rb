require File.dirname(__FILE__) + '/../test_helper'

class TitleTest < ActiveSupport::TestCase
  
  context "An instance of the Title class" do
    
    setup do
      @name = 'blurt.'
      Configuration.expects(:application).returns(stub(:name => @name))
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
    
  end
  
end