require 'test_helper'

class APIUrlTest < ActionDispatch::IntegrationTest

  # def create_url_api
  #   json = { url: "http://api.jquery.com/category/effects/fading/", unique_key: "5131238488789745" }.to_json
  #   post 'api_shorten_url/create.json', json
  #   assert_equal true, true
  # end

  test "Create a new url short valid data " do 

    params = {url: 'www.google.com',unique_key: '123456'}
    post 'api_shorten_url/create.json' , params
      
    assert_response :success
    assert_equal 1, Shortener::ShortenedUrl.count
    assert_equal 'http://www.google.com/', Shortener::ShortenedUrl.first.url
  end

  test "Create a new url short empty values" do 

    post 'api_shorten_url/create.json'
      
    assert_response 422
    assert_equal 0, Shortener::ShortenedUrl.count
  end

  test "Create a new url short blank values" do 

    params = {url: '',unique_key: ''}
    post 'api_shorten_url/create.json' , params
      
    assert_response 422
    assert_equal 0, Shortener::ShortenedUrl.count
  end

  test " Create a new url short param unique_key blank " do 

    params = {url: 'www.google.com'}
    post 'api_shorten_url/create.json' , params
      
    assert_response 422
    assert_equal 0, Shortener::ShortenedUrl.count
  end

  test " Create a new url short param url blank" do 

    params = {unique_key: 'asdffc1234dsasdjk'}
    post 'api_shorten_url/create.json' , params
      
    assert_response 422
    assert_equal 0, Shortener::ShortenedUrl.count
  end

  test "create a new short url and create an new url whit the same values " do 

    params = {url: 'www.google.com',unique_key: '123456'}
    post 'api_shorten_url/create.json' , params
      
    assert_response :success
    assert_equal 1, Shortener::ShortenedUrl.count
    assert_equal 'http://www.google.com/', Shortener::ShortenedUrl.first.url

    params = {url: 'www.google.com',unique_key: '123456'}
    post 'api_shorten_url/create.json' , params
      
    assert_response 422
    assert_equal 1, Shortener::ShortenedUrl.count
  end

  test "create a new short url if no stored in the database" do 

    params = {url: 'www.google.com',unique_key: '123456'}
    post 'api_shorten_url/create.json' , params
      
    assert_response :success
    assert_equal 1, Shortener::ShortenedUrl.count
    assert_equal 'http://www.google.com/', Shortener::ShortenedUrl.first.url

    params = {url: 'https://www.youtube.com/',unique_key: '7431258'}
    post 'api_shorten_url/create.json' , params
      
    assert_response :success
    assert_equal 2, Shortener::ShortenedUrl.count
  end
end