require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class TaggingTest < ActiveSupport::TestCase

  should_validate_presence_of :tag_id, :post_id
  should_belong_to :post, :tag

end
