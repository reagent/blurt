require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

  should_require_attributes :title, :body
  
  should_have_many :taggings
  should_have_many :tags
  
  context "An instance of the Post class" do
    
    should "have formattable content" do
      body = 'test'
      formatter = stub()
      
      post = Post.new(:body => body)
      Formatter::Code.stubs(:new).with(body).returns(formatter)
      
      assert_equal formatter, post.content
    end
    
  end
  
end
