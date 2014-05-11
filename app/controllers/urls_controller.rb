class UrlsController < ApplicationController
  http_basic_authenticate_with name: Setting.value('name'), password: Setting.value('password')
  skip_before_action :verify_authenticity_token

  def index
    redirect_to '/'
  end

  def new
  end

  def create
    @url = Shortener::ShortenedUrl.generate(params['url'])
    session['url'] = params['url']

    respond_to do |format|
      format.html { render :show }
    end
  end

  def show
    @url = Shortener::ShortenedUrl.generate(session['url'])
  end

end