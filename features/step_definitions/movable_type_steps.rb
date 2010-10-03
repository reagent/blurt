When /^I make an API call to "getCategoryList"$/ do
  @last_response = call_api('mt.getCategoryList', '0', @username, @password)
end

When /^I make an API call to "getPostCategories" for the latest post$/ do
  @last_response = call_api('mt.getPostCategories', most_recent_post.id, @username, @password)
end

When /^I make an API call to "setPostCategories" for the latest post with the categories "([^\"]*)"$/ do |category_list|
  category_names = category_list.strip.split(/\s*,\s*/)
  @last_response = call_api('mt.setPostCategories', most_recent_post.id, @username, @password, category_names)
end

When /^I make an API call to "publishPost" for the latest post$/ do
  @last_response = call_api('mt.publishPost', most_recent_post.id, @username, @password)
end

When /^I make an API call to "getRecentPostTitles" with a limit of "([^\"]*)"$/ do |limit|
  @last_response = call_api('mt.getRecentPostTitles', '0', @username, @password, limit.to_i)
end

Then /^the latest post should have the categories "([^\"]*)"$/ do |category_list|
  category_names = category_list.strip.split(/\s*,\s*/)
  assert_equal category_names.sort, most_recent_post.tag_names.sort
end

Then /^the latest post should be updated successfully$/ do
  assert_equal true, api_response
  assert_equal Time.now.to_s, most_recent_post.updated_at.to_s
end

# TODO: assert full struct somehow
Then /^I should receive the non\-primary categories:\s*(.+)$/ do |category_list|
  category_names = category_list.strip.split(/\s*,\s*/)
  
  assert_equal category_names.sort, api_response.map {|c| c['categoryName'] }
  assert_equal [false], api_response.map {|c| c['isPrimary']}.uniq
end