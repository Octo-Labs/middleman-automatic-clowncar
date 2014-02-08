Feature: Generating SVG clowncars during preview mode

  Scenario: Basic command
    Given a fixture app "automatic-clowncar-app"
    And a file named "source/not-index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg", :host => "http://localhost:4567/" %>
    """
    And the Server is running at "automatic-clowncar-app"
    When I go to "/not-index.html"
    Then I should see "<object"
    And I should see "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And I should see "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And I should see "@media%20screen%20and%20(min-width:401px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"

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
    And a file named "source/not-index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg" %>
    """
    And the Server is running at "automatic-clowncar-app"
    When I go to "/not-index.html"
    Then I should see "<object"
    And I should see "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And I should see "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And I should see "@media%20screen%20and%20(min-width:401px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"

  Scenario: With OldIE Fallback
    Given a fixture app "automatic-clowncar-app"
    And a file named "source/not-index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg", :host => "http://localhost:4567/", :fallback => true %>
    """
    And the Server is running at "automatic-clowncar-app"
    When I go to "/not-index.html"
    Then I should see "<object"
    And I should see "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And I should see "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And I should see "@media%20screen%20and%20(min-width:401px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"
    And I should see "<!--[if lte IE 8]>"
    And I should see '<img src="/photos/test-image/test-image-small.jpg">'
    And I should see "<![endif]-->"

  Scenario: With prevent_upscaling
    Given a fixture app "automatic-clowncar-app"
    And a file named "source/not-index.html.erb" with:
    """
    <%= automatic_clowncar_tag "photos/test-image.jpg", :host => "http://localhost:4567/", :prevent_upscaling => true %>
    """
    And the Server is running at "automatic-clowncar-app"
    When I go to "/not-index.html"
    Then I should see "<object"
    And I should see "@media%20screen%20and%20(max-width:200px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-small.jpg);%7D%7D"
    And I should see "@media%20screen%20and%20(min-width:201px)%20and%20(max-width:400px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-medium.jpg);%7D%7D"
    And I should see "@media%20screen%20and%20(min-width:401px)%7Bsvg%7Bbackground-image:url(http://localhost:4567/photos/test-image/test-image-large.jpg);%7D%7D"
    And I should see "max-width:1576px"
    

