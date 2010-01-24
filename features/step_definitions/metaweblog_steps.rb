require 'xmlrpc/marshal'

Given /^I have incorrect credentials$/ do
  @username = Blurt.configuration.username.reverse
  @password = Blurt.configuration.password.reverse
end

Given /^I have the correct credentials$/ do
  @username = Blurt.configuration.username
  @password = Blurt.configuration.password
end

Given /^(?:a post exists|I create (?:a post|posts)) with the following data:$/ do |table|
  table.hashes.each do |attributes|
    post_data             = attributes.symbolize_keys
    post_data[:tag_names] = post_data[:tag_names].split(/\s*,\s*/)

    # Delay to space out the create timestamps
    sleep 1 if table.hashes.size > 1

    @last_created = Factory(:post, post_data)
  end
end

Given /^a post exists$/ do
  @last_created = Factory(:post)
end

Given /^categories exist with the following data:$/ do |table|
  table.hashes.each do |attributes|
    Factory(:tag, attributes)
  end
end

Given /^a category exists$/ do
  Factory(:tag)
end

When /^I make an API call to "newPost" with the following data:$/ do |table|
  @sent_data = table.hashes.first.symbolize_keys
  struct     = @sent_data.dup

  struct[:categories] = struct[:categories].split(/\s*,\s*/)
  
  @last_response = call_api("metaWeblog.newPost", '0', @username, @password, struct, true)
end

When /^I make an API call to "getPost" for a post with an ID of (\d+)$/ do |post_id|
  @last_response = call_api("metaWeblog.getPost", post_id, @username, @password)
end

When /^I make an API call to "getPost" for the latest post$/ do
  post_id = @last_created.reload.id
  @last_response = call_api("metaWeblog.getPost", post_id, @username, @password)
end

When /^I make an API call to "getRecentPosts"(?: with a limit of (\d+))$/ do |limit|
  @last_response = call_api("metaWeblog.getRecentPosts", '0', @username, @password, limit)
end

When /^I make an API call to "editPost" for the latest post$/ do
  @last_response = call_api('metaWeblog.editPost', most_recent_post.id, @username, @password, {}, true)
end

When /^I make an API call to "editPost" for the latest post with:$/ do |table|
  struct = table.hashes.first.symbolize_keys
  struct[:categories] = struct[:categories].split(/\s*,\s*/)
  
  @last_response = call_api('metaWeblog.editPost', most_recent_post.id, @username, @password, struct, true)
end

When /^I make an API call to "getCategories"$/ do
  @last_response = call_api('metaWeblog.getCategories', '0', @username, @password)
end

When /^I make an API call to "newMediaObject" with the file "([^\"]*)"$/ do |filename|
  file_data = File.read(path_to_fixture(filename))

  struct = {
    :bits => XMLRPC::Base64.encode(file_data),
    :type => 'image/png',
    :name => filename
  }
  
  @last_response = call_api('metaWeblog.newMediaObject', '0', @username, @password, struct)
end

Then /^I should receive a (\d+) response$/ do |response_code|
  assert_status response_code
end

Then /^I should receive the correct response for the "newPost" call$/ do
  assert_equal most_recent_post.id.to_s, api_response
end

Then /^I should receive the correct response for the "getPost" call$/ do
  assert_post_without_date most_recent_post, api_response
end

Then /^I should receive the posts:\s*(.+)$/ do |post_titles|
  titles = post_titles.split(/\s*,\s*/)
  assert_equal titles, api_response.map {|r| r['title']}
end

Then /^I should receive a successful response for the "editPost" call$/ do
  assert_equal true, api_response
end

Then /^the (?:updated|new) post should have the attributes:$/ do |table|
  post = most_recent_post
  
  attributes = table.hashes.first.symbolize_keys
  
  assert_equal attributes[:title], post.title
  assert_equal attributes[:body], post.body
  assert_equal attributes[:tags].split(', '), post.tag_names
end

Then /^I should receive the categories:\s*(.+)$/ do |tag_names|
  names = tag_names.split(/\s*,\s*/)
  assert_equal names, api_response.map {|r| r['description']}
end

Then /^I should receive the proper response for the "newMediaObject" call$/ do
  media = Media.new('name' => 'image.png')
  assert_equal media.url, api_response['url']
end
