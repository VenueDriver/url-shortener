Feature: Dashboard Management
  As An admin I should be able to create short URLs with domain name
  and see list of previously generated short URLs

  Scenario: Admin fails to login into the dashboard
    Given our host is "hkk.sn"
    And I am an authorized user with credentials as name and password
    When I go to homepage and provide invalid_name and invalid_password
    Then I should see "HTTP Basic: Access denied"

  Scenario: Admin logs into the dashboard and creates a short URL
    Given our host is "hkk.sn"
    And I am an authorized user with credentials as name and password
    When I go to homepage and provide name and password
    Then I should see "Custom branded short URLs"
    And I should see "Create new short URL"
    When I click "Create new short URL"
    Then I should see "New hkk.sn URL"
    When I enter "http://external.com" into the input box as the URL in new url form
    And I enter "blah" into the input box as the short code in new url form
    And I submit the new url form
    Then I should have 1 Shorted URL with domain name as "hkk.sn"
    When I go to homepage
    Then I should see "hkk.sn/blah"
