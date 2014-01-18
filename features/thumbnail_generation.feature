Feature: Generating thumbnails

  Scenario: Basic useage
    Given a fixture app "automatic-clowncar-app"
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | images/photos/test_image.jpg |
    Then the following files should exist:
      | images/photos/test-image/test-image-small.jpg  |
      | images/photos/test-image/test-image-medium.jpg |
