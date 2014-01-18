Feature: Generating SVG clowncars during build mode

  Scenario: Basic command
    Given a fixture app "clowncar-app"
    And a file named "config.rb" with:
    """
    activate :clowncar
    generate_clowncar "logo"
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should exist:
      | images/logo.svg                                    |
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "images/logo.svg" should contain "<svg"
    And the file "images/logo.svg" should contain "@media screen and (max-width:300px){svg{background-image:url(logo/small.png);}}"
    And the file "images/logo.svg" should contain "@media screen and (min-width:301px) and (max-width:600px){svg{background-image:url(logo/medium.png);}}"
    And the file "images/logo.svg" should contain "@media screen and (min-width:601px){svg{background-image:url(logo/big.png);}}"

  Scenario: With custom sizes locally
    Given a fixture app "clowncar-app"
    And a file named "config.rb" with:
    """
    activate :clowncar
    generate_clowncar "logo", :sizes => { 768 => "big.png", 1024 => "medium.png", 1280 => "small.png" }
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should exist:
      | images/logo.svg                                    |
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "images/logo.svg" should contain "<svg"
    And the file "images/logo.svg" should contain "@media screen and (max-width:768px){svg{background-image:url(logo/big.png);}}"
    And the file "images/logo.svg" should contain "@media screen and (min-width:769px) and (max-width:1024px){svg{background-image:url(logo/medium.png);}}"
    And the file "images/logo.svg" should contain "@media screen and (min-width:1025px){svg{background-image:url(logo/small.png);}}"

  Scenario: With single size
    Given a fixture app "clowncar-app"
    And a file named "config.rb" with:
    """
    activate :clowncar
    generate_clowncar "logo", :sizes => { 768 => "big.png" }
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should exist:
      | images/logo.svg                                    |
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "images/logo.svg" should contain "<svg"
    And the file "images/logo.svg" should contain "svg{background-image:url(logo/big.png);}"

  Scenario: With custom sizes remotely
    Given a fixture app "clowncar-app"
    And a file named "config.rb" with:
    """
    activate :clowncar
    generate_clowncar "logo", :sizes => { 333 => "//remote.com/size-333", 768 => "//remote.com/size-768", 1024 => "//remote.com/size-1024" }
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should exist:
      | images/logo.svg                                    |
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "images/logo.svg" should contain "<svg"
    And the file "images/logo.svg" should contain "@media screen and (max-width:333px){svg{background-image:url(//remote.com/size-333);}}"
    And the file "images/logo.svg" should contain "@media screen and (min-width:334px) and (max-width:768px){svg{background-image:url(//remote.com/size-768);}}"
    And the file "images/logo.svg" should contain "@media screen and (min-width:769px){svg{background-image:url(//remote.com/size-1024);}}"
