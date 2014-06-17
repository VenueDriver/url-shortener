require 'test_helper'

class UrlsControllerTest < ActionController::TestCase
  setup do
    # Simulate an authenticated user.
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(
        Setting.value('name'), Setting.value('password'))

    @url = Shortener::ShortenedUrl.generate('example.com')
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:urls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create url" do
    assert_difference('Shortener::ShortenedUrl.count') do
      post :create, url: 'example.com/2'
    end

    assert_redirected_to url_path(assigns(:url))
  end

  test "should show url" do
    get :show, id: @url
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @url
    assert_response :success
  end

  test "should update url" do
    patch :update, id: @url, url: {  }
    assert_redirected_to url_path(assigns(:url))
  end

  test "should destroy url" do
    assert_difference('Shortener::ShortenedUrl.count', -1) do
      delete :destroy, id: @url
    end

    assert_redirected_to urls_path
  end
end
