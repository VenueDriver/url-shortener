require 'test_helper'
require 'fakeweb'
require_relative File.join(Rails.root, 'lib/url_validator')

class URLValidatorTest < ActiveSupport::TestCase

  def test_normalize_url
    assert_equal 'http://example.com/', URLValidator.new(url: 'example.com').to_s
  end

  def test_bad_url
    FakeWeb.register_uri(:get, 'http://example.com/',
      :body => 'NO.',
      :status => ["404", "Not Found"])
    assert_equal false, URLValidator.new(url: 'example.com').works?
  end

  def test_good_url
    FakeWeb.register_uri(:get, 'http://example.com/', :body => 'It works!')
    assert_equal true, URLValidator.new(url: 'example.com').works?
  end

end
