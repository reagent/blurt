require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < ActiveSupport::TestCase

  include ActionController::UrlWriter
  include ApplicationHelper

  context "The ApplicationHelper module" do

    context "when generating a list of tag links for a post" do
      setup do
        @tag = Factory(:tag)
        @post = Factory(:post, :tags => [@tag])
      end

      should "generate a list of tag links for a post" do
        self.expects(:link_to).with(@tag.name, tag_path(@tag), {})
        self.tag_links_for(@post)
      end

      should "allow passing of html attributes to the link functions" do
        self.expects(:link_to).with(@tag.name, tag_path(@tag), :class => 'foo')
        self.tag_links_for(@post, :class => 'foo')
      end

    end
  end

end