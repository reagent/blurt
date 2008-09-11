require File.dirname(__FILE__) + '/../../../test_helper'

class Api::Struct::PostTest < ActiveSupport::TestCase
  
  context "The Post class" do
    
    context "when instantiating itself from an ActiveRecord instance" do
      
      setup do
        @post         = Factory(:post)
        @post_struct  = Api::Struct::Post.from_active_record(@post)
      end
    
      should "have a :title" do
        assert_equal @post.title, @post_struct['title']
      end
      
      should "have a :description" do
        assert_equal @post.body, @post_struct['description']
      end
      
      should "have a :link" do
        assert_equal '', @post_struct['link']
      end
      
      should "have a :postid" do
        assert_equal @post.id.to_s, @post_struct['postid']
      end
      
    end
    
  end
  
end