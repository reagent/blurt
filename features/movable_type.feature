@rack_test @api @movable_type
Feature: Interacting with the MovableType API

  Scenario: Fetching categories without correct credentials
    Given I have incorrect credentials
    And a category exists
    When I make an API call to "getCategoryList"
    Then I should receive a 403 response
    
  Scenario: Fetching categories for a post without correct credentials
    Given I have incorrect credentials
    And I create a post with the following data:
      | title | body | tag_names |
      | Title | Body | One, Two  |
    When I make an API call to "getPostCategories" for the latest post
    Then I should receive a 403 response
    
  Scenario: Setting categories for a post without correct credentials
    Given I have incorrect credentials
    And a post exists with the following data:
      | title | body | tag_names |
      | Title | Body | One       |
    When I make an API call to "setPostCategories" for the latest post with the categories "Two"
    Then I should receive a 403 response
    
  Scenario: Publishing a post without the correct credentials
    Given I have incorrect credentials
    And a post exists
    When I make an API call to "publishPost" for the latest post
    Then I should receive a 403 response
  
  Scenario: Fetching post titles without the correct credentials
    Given I have incorrect credentials
    And posts exist with the following data:
      | title   | body   | tag_names |
      | Title 1 | Body 1 | One       |
      | Title 2 | Body 2 | Two       |
    When I make an API call to "getRecentPostTitles" with a limit of "1"
    Then I should receive a 403 response
    
  Scenario: Fetching categories with correct credentials
    Given I have the correct credentials
    And categories exist with the following data:
      | name      |
      | Aardvark  |
      | Xylophone |
    When I make an API call to "getCategoryList"
    Then I should receive a 200 response
    And I should receive the categories: Aardvark, Xylophone
  
  @slow
  Scenario: Fetching categories for a post with correct credentials
    Given I have the correct credentials
    And I create posts with the following data:
      | title     | body     | tag_names   |
      | Title One | Body One | One, Two    |
      | Title One | Body One | Three, Four |
    When I make an API call to "getPostCategories" for the latest post
    Then I should receive a 200 response
    And I should receive the non-primary categories: Four, Three
    
  Scenario: Setting categories for a post with correct credentials
    Given I have the correct credentials
    And a post exists with the following data:
      | title | body | tag_names |
      | Title | Body | One       |
    When I make an API call to "setPostCategories" for the latest post with the categories "Two, Three"
    Then I should receive a 200 response
    And the latest post should have the categories "Three, Two"

  Scenario: Publishing a post with the correct credentials
    Given I have the correct credentials
    And a post exists with the following data:
      | title | body | tag_names | updated_at          |
      | Title | Body | One       | 2009-08-01 00:00:00 |
    When I make an API call to "publishPost" for the latest post
    Then I should receive a 200 response
    And the latest post should be updated successfully 
  
  @wip
  Scenario: Fetching post titles without the correct credentials
    Given I have the correct credentials
    And posts exist with the following data:
      | title   | body   | tag_names |
      | Title 1 | Body 1 | One       |
      | Title 2 | Body 2 | Two       |
      | Title 3 | Body 3 | Three     |
    When I make an API call to "getRecentPostTitles" with a limit of "2"
    Then I should receive a 200 response
    And I should receive the posts: Title 3, Title 2

  Scenario: Getting a list of the supported methods
    Given I make an API call to "supportedMethods"
    Then I should receive a 200 response
