require 'test_helper'

class APIUrlTest < ActionDispatch::IntegrationTest

  # def create_url_api
  #   json = { url: "http://api.jquery.com/category/effects/fading/", unique_key: "5131238488789745" }.to_json
  #   post 'api_shorten_url/create.json', json
  #   assert_equal true, true
  # end

  test " Create a new url short  " do 

    params = {url: "google.com" , unique_key: "adsasdjk"}
    post "api_shorten_url/create.json" , params
    
    assert_response :success

  end

end