require File.dirname(__FILE__) + '/../../test_helper'

class NilClassTest < ActiveSupport::TestCase
  
  context "An instance of NilClass" do
    
    should "return an empty string as a slug" do
      assert_equal '', nil.sluggify
      
    end
    
  end
  
end