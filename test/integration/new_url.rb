require 'test_helper'

class APIUrlTest < ActionDispatch::IntegrationTest

  test "Create a new url with valid data" do 

    params = {url: 'www.google.com',unique_key: '123456'}
    post 'new_url/create.json' , params
      
    assert_response :success
    assert_equal 1, Shortener::ShortenedUrl.count
    assert_equal 'http://www.google.com/', Shortener::ShortenedUrl.first.url
  end

  test "Create a new url with no parameters" do 

    post 'new_url/create.json'
      
    assert_response 422
    assert_equal 0, Shortener::ShortenedUrl.count
  end

  test "Create a new url empty parameters" do 

    params = {url: '',unique_key: ''}
    post 'new_url/create.json' , params
      
    assert_response 422
    assert_equal 0, Shortener::ShortenedUrl.count
  end

  test " Create a new url without unique_key " do 

    params = {url: 'www.google.com'}
    post 'new_url/create.json' , params
      
    assert_response :success
    assert_equal 1, Shortener::ShortenedUrl.count
    assert_equal 'http://www.google.com/', Shortener::ShortenedUrl.first.url
  end

  test " Create a new url without url" do 

    params = {unique_key: 'asdffc1234dsasdjk'}
    post 'new_url/create.json' , params
      
    assert_response 422
    assert_equal 0, Shortener::ShortenedUrl.count
  end

  test "create a 2 urls with the same unique_key" do 

    params = {url: 'www.google.com',unique_key: '123456'}
    post 'new_url/create.json' , params
      
    assert_response :success
    assert_equal 1, Shortener::ShortenedUrl.count
    assert_equal 'http://www.google.com/', Shortener::ShortenedUrl.first.url

    params = {url: 'www.google.com',unique_key: '123456'}
    post 'new_url/create.json' , params
      
    assert_response 422
    assert_equal 1, Shortener::ShortenedUrl.count
  end

  test "create a 2 urls in a row" do 

    params = {url: 'www.google.com',unique_key: '123456'}
    post 'new_url/create.json' , params
      
    assert_response :success
    assert_equal 1, Shortener::ShortenedUrl.count
    assert_equal 'http://www.google.com/', Shortener::ShortenedUrl.first.url

    params = {url: 'https://www.youtube.com/',unique_key: '7431258'}
    post 'new_url/create.json' , params
      
    assert_response :success
    assert_equal 2, Shortener::ShortenedUrl.count
  end
  #########################################################
end