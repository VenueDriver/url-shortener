selector_context_to_id_map = {
  "domains dropdown" => "#domains_dropdown"
}

Given /^Our host is "([^\"]+)"$/ do |host|
  host! host
end

Given(/^I am an authorized user with credentials as (.*) and (.*)$/) do |username, password|
  FactoryGirl.create(:setting, key: 'name', value: username)
  FactoryGirl.create(:setting, key: 'password', value: password)
end

When(/^I go to homepage and provide (.*) and (.*)$/) do |username, password|
  authorize username, password
  visit root_url
end

Then /^I should see "([^\"]*)"$/ do |text|
  follow_redirect! if response.status == 302
  expect(response.body).to include(text)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  expect(response.body).not_to include(text)
end

Then /^I click "([^\"]*)"$/ do |button_text|
  click_link button_text
end

When(/^I go to homepage$/) do
  visit root_url
end

Then /^I should see "([^\"]*)" in (.*)$/ do |text, selector_context|
  expect(response).to have_selector(selector_context_to_id_map[selector_context], content: text)
end
