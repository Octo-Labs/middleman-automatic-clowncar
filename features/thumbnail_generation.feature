Feature: Generating thumbnails

  Scenario: Basic useage during build
    Given a fixture app "automatic-clowncar-app"
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | photos/test_image.jpg |
    Then the following files should exist:
      | photos/test-image/test-image-small.jpg  |
      | photos/test-image/test-image-medium.jpg |
      | photos/test-image/test-image-large.jpg |

  Scenario: Basic useage during preview
    Given a fixture app "automatic-clowncar-app"
    And the Server is running at "automatic-clowncar-app"
    #Given the Server is running at "automatic-clowncar-app"
    When I go to "/photos/test-image/test-image-small.jpg"
    Then the content type should be "image/jpeg"
    When I go to "/photos/test-image/test-image-medium.jpg"
    Then the content type should be "image/jpeg"
    When I go to "/photos/test-image/test-image-large.jpg"
    Then the content type should be "image/jpeg"
    When I go to "/photos/test-image/timestamp.txt"
    Then the content type should be "text"


  Scenario: Generating a timestamp file
    Given a fixture app "automatic-clowncar-app"
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | photos/test_image.jpg |
    Then the following files should exist:
      | photos/test-image/test-image-small.jpg  |
      | photos/test-image/test-image-medium.jpg |
      | photos/test-image/test-image-large.jpg  |
      | photos/test-image/timestamp.txt         |

  Scenario: Avoiding regeneration
    Given a fixture app "automatic-clowncar-app"
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    Given the file "build/photos/test-image/test-image-small.jpg" has been overwritten with "build/photos/test-image/test-image-medium.jpg"
    Given a modification time for a file named "build/photos/test-image/test-image-small.jpg"
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    Then the file "build/photos/test-image/test-image-small.jpg" should not have been updated
    #When I cd to "build"
    #Then the following files should not exist:
      #| photos/test-image/test-image-small.jpg  |
      #| photos/test-image/test-image-medium.jpg |
      #| photos/test-image/test-image-large.jpg  |
    #Then the following files should exist:
      #| photos/test-image/timestamp.txt         |



