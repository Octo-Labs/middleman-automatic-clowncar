Feature: Generating thumbnails

  Scenario: Basic useage during build
    Given a fixture app "automatic-clowncar-app"
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | images/photos/test_image.jpg |
    Then the following files should exist:
      | images/photos/test-image/test-image-small.jpg  |
      | images/photos/test-image/test-image-medium.jpg |
      | images/photos/test-image/test-image-large.jpg |

  Scenario: Basic useage during preview
    Given a fixture app "automatic-clowncar-app"
    And the Server is running at "automatic-clowncar-app"
    When I go to "/images/photos/test-image/test-image-small.jpg"
    Then the content type should be "image/jpeg"
    When I go to "/images/photos/test-image/test-image-medium.jpg"
    Then the content type should be "image/jpeg"
    When I go to "/images/photos/test-image/test-image-large.jpg"
    Then the content type should be "image/jpeg"


  Scenario: Generating a timestamp file
    Given a fixture app "automatic-clowncar-app"
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | images/photos/test_image.jpg |
    Then the following files should exist:
      | images/photos/test-image/test-image-small.jpg  |
      | images/photos/test-image/test-image-medium.jpg |
      | images/photos/test-image/test-image-large.jpg  |
      | images/photos/test-image/timestamp.txt         |

  Scenario: Avoiding regeneration
    Given a fixture app "automatic-clowncar-app"
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | images/photos/test_image.jpg |
    Then the following files should exist:
      | images/photos/test-image/test-image-small.jpg  |
      | images/photos/test-image/test-image-medium.jpg |
      | images/photos/test-image/test-image-large.jpg  |
      | images/photos/test-image/timestamp.txt         |
    When the generated files for "photos/test-image" are removed
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    Then the following files should not exist:
      | images/photos/test-image/test-image-small.jpg  |
      | images/photos/test-image/test-image-medium.jpg |
      | images/photos/test-image/test-image-large.jpg  |
    Then the following files should exist:
      | images/photos/test-image/timestamp.txt         |



