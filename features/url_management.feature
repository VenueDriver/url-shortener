Feature: URL Management
  As An admin I should be able to create short URLs with domain name
  and see list of previously generated short URLs

  @admin
  Scenario: Dashboard Admin shortens URLs for more than one domain at once
    Given Our host is "hkk.sn"
      And I am an authorized user with credentials as name and password
      And there is a shortened URL http://omnia.ws/blah1 that goes to http://example1.com/
     When I go to homepage and provide name and password
     Then I should see "Custom branded short URLs"
      And I should see "Create new short URL"
     When I click "Create new short URL"
     Then I should see "New URL"
      And I should see "hkk.sn" domain checkbox as checked
      And I should see "omnia.ws" domain checkbox as checked
     When I enter "http://external.com" into the input box as the URL in new url form
      And I enter "blah" into the input box as the short code in new url form
      And I submit the new url form
     Then I should have 1 Shorted URL with domain name as "hkk.sn"
      And I should have 2 Shorted URL with domain name as "omnia.ws"
      And I should have Shorted URL with "hkk.sn/blah" as url and "http://external.com" as target
      And I should have Shorted URL with "omnia.ws/blah" as url and "http://external.com" as target
     When I go to homepage
     Then I should see "hkk.sn/blah"
      And I should see "omnia.ws/blah"

  @admin
  Scenario: Dashboard Admin shortens URLs for the selected domain by default
    Given Our host is "hkk.sn"
      And I am an authorized user with credentials as name and password
      And there is a shortened URL http://omnia.ws/blah1 that goes to http://example1.com/
     When I go to homepage and provide name and password
      And I select omnia.ws in domains dropdown
     Then I should see "Custom branded short URLs"
      And I should see "Create new short URL"
     When I click "Create new short URL"
     Then I should see "New URL"
      And I should see "hkk.sn" domain checkbox as unchecked
      And I should see "omnia.ws" domain checkbox as checked
     When I enter "http://external.com" into the input box as the URL in new url form
      And I enter "blah" into the input box as the short code in new url form
      And I submit the new url form
     Then I should have 0 Shorted URL with domain name as "hkk.sn"
      And I should have 2 Shorted URL with domain name as "omnia.ws"
      And I should have Shorted URL with "omnia.ws/blah" as url and "http://external.com" as target
     When I go to homepage
     Then I should not see "hkk.sn/blah"
      And I should see "omnia.ws/blah"

  @admin
  Scenario: Dashboard Admin fails to shortens URLs and is provided proper error messages
    Given Our host is "hkk.sn"
      And I am an authorized user with credentials as name and password
      And there is a shortened URL http://omnia.ws/blah that goes to http://external.com/
     When I go to homepage and provide name and password
     Then I should see "Custom branded short URLs"
      And I should see "Create new short URL"
     When I click "Create new short URL"
     Then I should see "New URL"
      And I should see "hkk.sn" domain checkbox as checked
      And I should see "omnia.ws" domain checkbox as checked
     When I enter "http://external.com" into the input box as the URL in new url form
      And I enter "blah" into the input box as the short code in new url form
      And I submit the new url form
     Then I should have 0 Shorted URL with domain name as "hkk.sn"
      And I should have 1 Shorted URL with domain name as "omnia.ws"
      And I should see "That short code already exists for omnia.ws."
