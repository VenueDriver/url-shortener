When(/^I enter "([^"]*)" into the input box as the URL in new url form$/) do |value|
  fill_in "url", with: value
end

When(/^I enter "([^"]*)" into the input box as the short code in new url form$/) do |value|
  fill_in "unique_key", with: value
end

When(/^I submit the new url form$/) do
  click_button "Create URL"
end

Then(/^I should have (\d+) Shorted URL$/) do |count|
  expect(Shortener::ShortenedUrl.count).to eq count.to_i
end

Then(/^I should have (\d+) Shorted URL with domain name as "([^"]*)"$/) do |count, domain_name|
  expect(Shortener::ShortenedUrl.where(domain_name: domain_name).count).to eq count.to_i
end

Then /^I should see "([^\"]*)" domain checkbox as checked$/ do |domain|
  expect(response).to have_selector("input", id: "domain_name_input_#{domain}", checked: "checked")
end
