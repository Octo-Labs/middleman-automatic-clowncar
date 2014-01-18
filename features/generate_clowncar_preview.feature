Feature: Generating SVG clowncars during preview mode

  Scenario: Basic command
    Given a fixture app "clowncar-app"
    And a file named "config.rb" with:
    """
    activate :clowncar
    generate_clowncar "logo"
    """
    And the Server is running at "clowncar-app"
    When I go to "/images/logo.svg"
    Then I should see "<svg"
    And I should see "@media screen and (max-width:300px){svg{background-image:url(logo/small.png);}}"
    And I should see "@media screen and (min-width:301px) and (max-width:600px){svg{background-image:url(logo/medium.png);}}"
    And I should see "@media screen and (min-width:601px){svg{background-image:url(logo/big.png);}}"

  Scenario: With custom sizes locally
    Given a fixture app "clowncar-app"
    And a file named "config.rb" with:
    """
    activate :clowncar
    generate_clowncar "logo", :sizes => { 768 => "big.png", 1024 => "medium.png", 1280 => "small.png" }
    """
    And the Server is running at "clowncar-app"
    When I go to "/images/logo.svg"
    Then I should see "<svg"
    And I should see "@media screen and (max-width:768px){svg{background-image:url(logo/big.png);}}"
    And I should see "@media screen and (min-width:769px) and (max-width:1024px){svg{background-image:url(logo/medium.png);}}"
    And I should see "@media screen and (min-width:1025px){svg{background-image:url(logo/small.png);}}"

  Scenario: With single size
    Given a fixture app "clowncar-app"
    And a file named "config.rb" with:
    """
    activate :clowncar
    generate_clowncar "logo", :sizes => { 768 => "big.png" }
    """
    And the Server is running at "clowncar-app"
    When I go to "/images/logo.svg"
    Then I should see "<svg"
    And I should see "svg{background-image:url(logo/big.png);}"

  Scenario: With custom sizes remotely
    Given a fixture app "clowncar-app"
    And a file named "config.rb" with:
    """
    activate :clowncar
    generate_clowncar "logo", :sizes => { 333 => "//remote.com/size-333", 768 => "//remote.com/size-768", 1024 => "//remote.com/size-1024" }
    """
    And the Server is running at "clowncar-app"
    When I go to "/images/logo.svg"
    Then I should see "<svg"
    And I should see "@media screen and (max-width:333px){svg{background-image:url(//remote.com/size-333);}}"
    And I should see "@media screen and (min-width:334px) and (max-width:768px){svg{background-image:url(//remote.com/size-768);}}"
    And I should see "@media screen and (min-width:769px){svg{background-image:url(//remote.com/size-1024);}}"
