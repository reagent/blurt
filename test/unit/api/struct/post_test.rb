require File.dirname(__FILE__) + '/../../../test_helper'

class Api::Struct::PostTest < ActiveSupport::TestCase
  
  context "The Post class" do
    
    context "when instantiating itself from an ActiveRecord instance" do
      
      setup do
        @post         = Factory(:post, :tag_names => ['tag'])
        @post_struct  = Api::Struct::Post.from_active_record(@post)
      end
    
      should "have a :title" do
        assert_equal @post.title, @post_struct['title']
      end
      
      should "have a :description" do
        assert_equal @post.content.to_s, @post_struct['description']
      end
      
      should "have a :link" do
        assert_equal '', @post_struct['link']
      end
      
      should "have a :postid" do
        assert_equal @post.id.to_s, @post_struct['postid']
      end
      
      should "have a :dateCreated" do
        assert_equal @post.created_at, @post_struct['dateCreated']
      end
      
      should "have a list of :categories" do
        assert_equal @post.tag_names, @post_struct['categories']
      end
      
    end
    
  end
  
end