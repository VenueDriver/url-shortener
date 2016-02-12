When(/^I enter "([^"]*)" in search field of short url$/) do |query|
  fill_in "short_url_query_input", with: query
end

When(/^I press Search button of short url search form$/) do
  click_button "Search"
end

When(/^I select (.*) in domains dropdown$/) do |domain_name|
  click_link domain_name, method: :post
end
