Given /^I visit "([^\"]*)"$/ do |path|
  visit path
end

Given /^no posts exist$/ do
  Post.destroy_all
end

Given /^1 full page of posts exists$/ do
  post_count     = Post.count
  required_count = Blurt.configuration.per_page - post_count

  (1..required_count).each {|i| Factory(:post, :title => "Post ##{i}") }
end

Given /^(?:a post exists|I create a post) with the title "([^\"]*)"$/ do |title|
  Factory(:post, :title => title)
end

Given /^the following tags exist:$/ do |table|
  table.hashes.each {|hash| Factory.create(:tag, hash) }
end

Given /^a post exists with the title "([^\"]*)" and is tagged with "([^\"]*)"$/ do |post_title, tag|
  Factory(:post, :title => post_title, :tag_names => [tag])
end

Then /^I should be redirected to "([^\"]*)"$/ do |path|
  current_path = URI.parse(current_url).path
  assert_equal path, current_path
end

Then /^I should remain on "([^\"]*)"$/ do |path|
  current_path = URI.parse(current_url).path
  assert_equal path, current_path
end

Then /^I should (not )?see "([^\"]*)"$/ do |assertion, content|
  expected = assertion.nil? ? true : false
  assert_equal expected, has_content?(content)
end

Then /^I should see the blog name and tagline in the title$/ do
  title = "#{Blurt.configuration.name} | #{Blurt.configuration.tagline}"
  within('//title') { has_content?(title) }
end

Then /^I should see "([^\"]*)" and blog name in the title$/ do |entity_name|
  title = "#{entity_name} | #{Blurt.configuration.name}"
  within('//title') { has_content?(title) }
end

Then /^the content-type of the page should be "([^\"]*)"$/ do |content_type|
  assert_equal content_type, response_header('Content-Type')
  # raise Capybara.current_session.response_headersinspect
  # assert_equal content_type, response_headers['Content-Type']
end

Then /^I should see an empty sitemap XML file$/ do
  options = {
    :root_url => Blurt.configuration.url + '/'
  }
  
  expected = evaluate_fixture(:sitemap, options)
  assert_equal expected, body
end

Then /^I should see an empty RSS feed$/ do
  options = {
    :title       => Blurt.configuration.name,
    :description => Blurt.configuration.tagline,
    :root_url    => Blurt.configuration.url + '/'
  }
  
  expected = evaluate_fixture(:feed, options)
  assert_equal expected, body
end
