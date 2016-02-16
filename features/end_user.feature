Feature: End User Feature
  As an End User I should be able to use shortend urls to access full urls

  @end_user
  Scenario: End User uses shortend url and is redirected to full url
    Given Our host is "hkk.sn"
      And that I am an end user
      And there is a shortened URL http://hkk.sn/blah that goes to http://example.com/
     When I access http://hkk.sn/blah
     Then I should be redirected to http://example.com/
