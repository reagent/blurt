require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

  should_require_attributes :title, :body
  
end
