@rack_test @api @metaweblog
Feature: Interacting with the Metaweblog API

  Scenario: Creating a new post without correct credentials
    Given I have incorrect credentials
    When I make an API call to "newPost" with the following data:
      | title | description | categories      |
      | Title | Body        | Rails, Cucumber |
    Then I should receive a 403 response

  Scenario: Fetching a post without correct credentials
    Given I have incorrect credentials
    And a post exists
    When I make an API call to "getPost" for the latest post
    Then I should receive a 403 response

  Scenario: Fetching posts without correct credentials
    Given I have incorrect credentials
    And a post exists
    When I make an API call to "getRecentPosts" with a limit of 10
    Then I should receive a 403 response
    
  Scenario: Editing a post without correct credentials
    Given I have incorrect credentials
    And a post exists
    When I make an API call to "editPost" for the latest post with:
      | title | description | categories |
      | Yours | Yours       | Fails      |
    Then I should receive a 403 response
    
  Scenario: Fetching categories without correct credentials
    Given I have incorrect credentials
    And a category exists
    When I make an API call to "getCategories"
    Then I should receive a 403 response
  
  Scenario: Adding media without correct credentials
    Given I have incorrect credentials
    When I make an API call to "newMediaObject" with the file "image.png"
    Then I should receive a 403 response
  
  Scenario: Creating a new post with correct credentials
    Given I have the correct credentials
    When I make an API call to "newPost" with the following data:
      | title      | description | categories           |
      | A New Post | Noob        | Rails, Testing       |
    Then I should receive a 200 response
    And I should receive the correct response for the "newPost" call
    And the new post should have the attributes:
      | title      | body | tags           |
      | A New Post | Noob | Rails, Testing |

  Scenario: Fetching a post with correct credentials
    Given I have the correct credentials
    And I create a post with the following data:
      | title | body | tag_names |
      | Title | Body | One, Two  |
    When I make an API call to "getPost" for the latest post
    Then I should receive a 200 response
    And I should receive the correct response for the "getPost" call
  
  @slow
  Scenario: Fetching recent posts with correct credentials
    Given I have the correct credentials
    And I create posts with the following data:
      | title | body  | tag_names |
      | Older | Older | First     |
      | Newer | Newer | Second    |
    When I make an API call to "getRecentPosts" with a limit of 10
    Then I should receive a 200 response
    And I should receive the posts: Newer, Older
  
  @slow
  Scenario: Fetching recent posts with a limit
    Given I have the correct credentials
    And I create posts with the following data:
      | title | body  | tag_names |
      | Older | Older | First     |
      | Newer | Newer | Second    |
    When I make an API call to "getRecentPosts" with a limit of 1
    Then I should receive the posts: Newer
  
  Scenario: Editing a post with correct credentials
    Given I have the correct credentials
    And a post exists with the following data:
      | title | body | tag_names |
      | Mine  | Mine | Rails     |
    When I make an API call to "editPost" for the latest post with:
      | title | description | categories |
      | Yours | Yours       | Fails      |
    Then I should receive a 200 response
    And I should receive a successful response for the "editPost" call
    And the updated post should have the attributes:
      | title | body  | tags  |
      | Yours | Yours | Fails |
  
  Scenario: Fetching categories with correct credentials
    Given I have the correct credentials
    And categories exist with the following data:
      | name      |
      | Aardvark  |
      | Xylophone |
    When I make an API call to "getCategories"
    Then I should receive a 200 response
    And I should receive the categories: Aardvark, Xylophone
    
  Scenario: Adding media with correct credentials
    Given I have the correct credentials
    When I make an API call to "newMediaObject" with the file "image.png"
    Then I should receive a 200 response
    And I should receive the proper response for the "newMediaObject" call
    