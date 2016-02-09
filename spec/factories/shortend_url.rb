FactoryGirl.define do
  factory :shortend_url, class: Shortener::ShortenedUrl do
    domain_name "domain.com"
    url "http://url.com/"
    unique_key "short"
  end
end
