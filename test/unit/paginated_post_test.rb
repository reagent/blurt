require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PaginatedPostTest < ActiveSupport::TestCase
  
  context "An instance of Paginated Post" do
    
    should "know the current page" do
      pp = PaginatedPost.new(:page => 1)
      assert_equal 1, pp.current_page
    end
    
    should "convert page numbers to integers" do
      pp = PaginatedPost.new(:page => '1')
      assert_equal 1, pp.current_page
    end
    
    should "know that there is a next page" do
      Post.stubs(:page_count).with().returns(2)
      pp = PaginatedPost.new(:page => 1)
      assert_equal true, pp.next_page?
    end
    
    should "know that there isn't a next page" do
      Post.stubs(:page_count).with().returns(1)
      pp = PaginatedPost.new(:page => 1)
      
      assert_equal false, pp.next_page?
    end

    should "know the next page" do
      Post.stubs(:page_count).with().returns(2)
      pp = PaginatedPost.new(:page => 1)
      
      assert_equal 2, pp.next_page
    end
    
    should "return the maximum page for the next page if there is no next page" do
      Post.stubs(:page_count).with().returns(2)
      pp = PaginatedPost.new(:page => 2)
      pp.stubs(:next_page?).with().returns(false)
      
      assert_equal 2, pp.next_page
    end
    
    should "know that there is a previous page" do
      pp = PaginatedPost.new(:page => 2)
      assert_equal true, pp.previous_page?
    end
    
    should "know that there isn't a previous page" do
      pp = PaginatedPost.new(:page => 1)
      assert_equal false, pp.previous_page?
    end
    
    should "know the previous page" do
      pp = PaginatedPost.new(:page => 2)
      assert_equal 1, pp.previous_page
    end
    
    should "return '1' for previous page if there is no previous page" do
      pp = PaginatedPost.new(:page => 1)
      pp.stubs(:previous_page?).with().returns(false)
      
      assert_equal 1, pp.previous_page
    end
    
    should "generate a default :limit and :offset conditions for ActiveRecord" do
      Post.stubs(:per_page).with().returns(10)
      pp = PaginatedPost.new(:page => 1)
      
      assert_equal({:offset => 0, :limit => 10}, pp.conditions)
    end
    
    should "generate the correct :limit and :offset conditions for higher-indexed pages" do
      Post.stubs(:per_page).with().returns(10)
      pp = PaginatedPost.new(:page => 2)
      
      assert_equal({:offset => 10, :limit => 10}, pp.conditions)
    end
    
    should "return a list of posts" do
      post = stub()
      Post.stubs(:per_page).with().returns(10)
      
      Post.stubs(:by_date).with().returns(
        mock() {|m| m.expects(:find).with(:all, :offset => 0, :limit => 10).returns([post])}
      )
      
      pp = PaginatedPost.new(:page => 1)
      
      assert_equal [post], pp.posts
    end
    
  end
  
end