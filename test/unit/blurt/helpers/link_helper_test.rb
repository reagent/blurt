require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module Blurt
  module Helpers
    
    class LinkHelperTest < ActiveSupport::TestCase
      
      include Blurt::Helpers::LinkHelper
      
      context "The LinkHelper module" do

        should "be able to link to content" do
          assert_equal '<a href="http://google.com">google</a>', self.link_to('google', 'http://google.com')
        end
        
        should "accept options in the generated link" do
          assert_equal '<a href="http://google.com" class="hardly">google</a>', self.link_to('google', 'http://google.com', :class => 'hardly')
        end

        context "when generating a list of tag links for a post" do
          setup do
            @tag = Factory(:tag)
            @post = Factory(:post, :tags => [@tag])
          end

          should "generate a list of tag links for a post" do
            self.expects(:link_to).with(@tag.name, tag_url(@tag), {})
            self.tag_links_for(@post)
          end

          should "allow passing of html attributes to the link functions" do
            self.expects(:link_to).with(@tag.name, tag_url(@tag), :class => 'foo')
            self.tag_links_for(@post, :class => 'foo')
          end
        end
    
        context "when linking to post pages" do
              
          should "link to the next page when there are pages available" do
            paginated_post = stub(:next_page? => true, :next_page => 2)
            self.expects(:link_to).with('Next Page >>', page_url(2))
        
            link_to_next_page(paginated_post)
          end
              
          should "return nil when linking to a non-existent next page" do
            paginated_post = stub(:next_page? => false)
            assert_nil link_to_next_page(paginated_post)
          end
              
          should "link to the previous page when there is a page available" do
            paginated_post = stub(:previous_page? => true, :previous_page => 1)
            self.expects(:link_to).with('<< Previous Page', page_url(1))
        
            link_to_previous_page(paginated_post)
          end
              
          should "return nil when linking to a non-existent previous page" do
            paginated_post = stub(:previous_page? => false)
            assert_nil link_to_previous_page(paginated_post)
          end
              
        end
    
      end
    end

  end
end