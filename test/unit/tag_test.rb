require File.dirname(__FILE__) + '/../test_helper'

class TagTest < ActiveSupport::TestCase

  should_have_many :taggings
  should_require_attributes :name
  
end
