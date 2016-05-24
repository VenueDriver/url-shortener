Feature: Dashboard Management
  As An admin I should be able to manage the unified admin dashboard 
  to manage urls of multiple domain names

  @admin
  Scenario: Admin fails to login into the dashboard
    Given Our host is "hkk.sn"
      And I am an authorized user with credentials as name and password
     When I go to homepage and provide invalid_name and invalid_password
     Then I should see "HTTP Basic: Access denied"

  @admin
  Scenario: Admin successfully logs in and can see Dashboard and all domains
    Given Our host is "random.com"
      And there is a shortened URL http://hkk.sn/blah1 that goes to http://example1.com/
      And there is a shortened URL http://omnia.ws/blah2 that goes to http://example2.com/
      And I am an authorized user with credentials as name and password
     When I go to homepage and provide name and password
     Then I should see "Custom branded short URLs"
      And I should see "Create new short URL"
      And I should see "Domains"
      And I should see "All" in domains dropdown
      And I should see "hkk.sn" in domains dropdown
      And I should see "omnia.ws" in domains dropdown
      And I should see "random.com" in domains dropdown
     
  @admin
  Scenario: Admin searches for shortend URL to filter URLs by name
    Given Our host is "hkk.sn"
      And I am an authorized user with credentials as name and password
      And there is a shortened URL http://hkk.sn/blah1 that goes to http://example1.com/
      And there is a shortened URL http://hkk.sn/blah2 that goes to http://example2.com/
     When I go to homepage and provide name and password
     Then I should see "hkk.sn/blah1"
      And I should see "hkk.sn/blah2"
      And I should see "Enter Short URL"
      And I should see "Search"
     When I enter "blah1" in search field of short url
      And I press Search button of short url search form
     Then I should see "hkk.sn/blah1"
      And I should not see "hkk.sn/blah2"

  @admin
  Scenario: Admin should be able to see list of shortend URLs of all domains and filter by domain
    Given I am an authorized user with credentials as name and password
      And there is a shortened URL http://hkk.sn/blah1 that goes to http://example1.com/
      And there is a shortened URL http://omnia.ws/blah2 that goes to http://example2.com/
     When I go to homepage and provide name and password
     Then I should see "hkk.sn/blah1"
      And I should see "omnia.ws/blah2"
     When I select hkk.sn in domains dropdown
      And I should see "hkk.sn/blah1"
      And I should not see "omnia.ws/blah2"
