Feature: Generating SVG clowncars during preview mode

  Scenario: Basic command
    Given a fixture app "automatic-clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg", :host => "http://localhost:4567/" %>
    """
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | photos/test-image.jpg                       |
    Then the following files should exist:
      | photos/test-image.jpg                       |
      | photos/test-image/test-image-small.jpg      |
      | photos/test-image/test-image-medium.jpg     |
      | photos/test-image/test-image-large.jpg      |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:401px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"

  Scenario: Basic command with asset_host
    Given a fixture app "automatic-clowncar-app"
    And a file named "config.rb" with:
    """
    activate :automatic_clowncar,
      :sizes => {
        :small => 200,
        :medium => 400,
        :large => 600
      },
      :namespace_directory => %w(photos)
    activate :asset_host, :host => "http://localhost:4567/"
    """
    And a file named "source/index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg" %>
    """
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | photos/test-image.jpg
    Then the following files should exist:
      | photos/test-image/test-image-small.jpg      |
      | photos/test-image/test-image-medium.jpg      |
      | photos/test-image/test-image-large.jpg      |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:401px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"

  Scenario: With OldIE Fallback
    Given a fixture app "automatic-clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg", :host => "http://localhost:4567/", :fallback => true %>
    """
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | photos/test-image.jpg
    Then the following files should exist:
      | photos/test-image/test-image-small.jpg      |
      | photos/test-image/test-image-medium.jpg      |
      | photos/test-image/test-image-large.jpg                                |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:401px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"
    And the file "index.html" should contain "<!--[if lte IE 8]>"
    And the file "index.html" should contain '<img src="/photos/test-image/test-image-small.jpg">'
    And the file "index.html" should contain "<![endif]-->"


  Scenario: With prevent_upscaling
    Given a fixture app "automatic-clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg", :host => "http://localhost:4567/", :prevent_upscaling => true %>
    """
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | photos/test-image.jpg
    Then the following files should exist:
      | photos/test-image/test-image-small.jpg      |
      | photos/test-image/test-image-medium.jpg      |
      | photos/test-image/test-image-large.jpg                                |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:401px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"
    And the file "index.html" should contain "max-width:1576px"

  Scenario: Including originals
    Given a fixture app "automatic-clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg", :host => "http://localhost:4567/", :include_original => true %>
    """
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | photos/test-image.jpg                       |
    Then the following files should exist:
      | photos/test-image.jpg                       |
      | photos/test-image/test-image-small.jpg      |
      | photos/test-image/test-image-medium.jpg     |
      | photos/test-image/test-image-large.jpg      |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:401px)%20and%20(max-width:600px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:601px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/../test-image.jpg);%7D%7D"

  Scenario: Don't generate upscaled images
    Given a fixture app "automatic-clowncar-app"
    And a file named "config.rb" with:
    """
    activate :automatic_clowncar,
      :sizes => {
        :small => 200,
        :medium => 400,
        :huge => 3000
      },
      :namespace_directory => %w(photos)
    activate :asset_host, :host => "http://localhost:4567/"
    """
    And a file named "source/index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg" %>
    """
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    Then the following files should not exist:
      | photos/test-image/test-image-huge.jpg  |
    Then the following files should exist:
      | photos/test-image/test-image-small.jpg      |
      | photos/test-image/test-image-medium.jpg      |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:201px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And the file "index.html" should not contain "test-image-huge.jpg"

  Scenario: Including originals at the top level
    Given a fixture app "automatic-clowncar-app"
    And a file named "config.rb" with:
    """
    activate :automatic_clowncar,
      :sizes => {
        :small => 200,
        :medium => 400,
        :large => 600
      },
      :namespace_directory => %w(photos),
      :include_originals => true
    activate :asset_host, :host => "http://localhost:4567/"
    """
    And a file named "source/index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg" %>
    """
    Given a successfully built app at "automatic-clowncar-app" with flags "--verbose"
    When I cd to "build"
    #Then the following files should not exist:
    #  | photos/test-image.jpg                       |
    Then the following files should exist:
      | photos/test-image.jpg                       |
      | photos/test-image/test-image-small.jpg      |
      | photos/test-image/test-image-medium.jpg     |
      | photos/test-image/test-image-large.jpg      |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:401px)%20and%20(max-width:600px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:601px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/../test-image.jpg);%7D%7D"


