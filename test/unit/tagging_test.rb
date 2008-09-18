require File.dirname(__FILE__) + '/../test_helper'

class TaggingTest < ActiveSupport::TestCase

  should_require_attributes :tag_id, :post_id
  should_belong_to :post, :tag

end
