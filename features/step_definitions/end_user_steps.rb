Given(/^that I am an end user$/) do
  
end

Given(/^there is a shortened URL (http|https):\/\/(.*)\/(.*) that goes to (.*)$/) do |protocol, domain_name, short_path, url|
  url = FactoryGirl.create :shortend_url, domain_name: domain_name, url: url
  url.unique_key = short_path
  url.save
end

When(/^I access (.*)$/) do |url|
  VCR.use_cassette("cassette_name") { visit(url) }
end

Then(/^I should be redirected to (.*)$/) do |url|
  expect(response.original_headers["Location"]).to eq url
  expect(response.status).to eq 301
end
