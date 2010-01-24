Feature: Viewing the front-end

  Scenario: Viewing the home page
    Given I visit "/"
    Then I should remain on "/"
    And I should see the blog name and tagline in the title
  
  Scenario: Viewing a single post
    Given a post exists with the title "A New Post"
    When I visit "/a-new-post"
    Then I should see "A New Post"
    And I should see "A New Post" and blog name in the title
  
  Scenario: Viewing a post that doesn't exist
    Given no posts exist
    When I visit "/a-post"
    Then I should be redirected to "/"

  Scenario: Viewing a list of tags
    Given the following tags exist:
      | name     |
      | Rails    |
      | Cucumber |
    When I visit "/tags"
    Then I should see "Cucumber"
    And I should see "Rails"
  
  Scenario: Viewing posts for a tag
    Given a post exists with the title "Rails post" and is tagged with "Rails"
    And a post exists with the title "Cucumber post" and is tagged with "Cucumber"
    When I visit "/tag/rails"
    Then I should see "Rails post"
    And I should not see "Cucumber post"
    And I should see "Rails" and blog name in the title

  Scenario: Viewing the default sitemap
    Given no posts exist
    When I visit "/sitemap.xml"
    Then I should see an empty sitemap XML file
    And the content-type of the page should be "text/xml"

  Scenario: Viewing the default RSS feed
    Given no posts exist
    When I visit "/feed"
    Then I should see an empty RSS feed
    And the content-type of the page should be "application/xml"
    
  Scenario: Viewing the second page
    Given a post exists with the title "First post"
    And 1 full page of posts exists
    When I create a post with the title "Page 2"
    And I visit "/page/2"
    Then I should see "Page 2"
    And I should not see "First post"
    