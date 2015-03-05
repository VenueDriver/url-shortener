require 'url_validator'

class UrlsController < ApplicationController
  http_basic_authenticate_with name: Setting.value('name'), password: Setting.value('password'),
  except: :expand
  skip_before_action :verify_authenticity_token
  before_action :set_url, only: [:show, :edit, :update]
  
  include ApplicationHelper
  include NewUrlHelper

  def index
    @urls = Shortener::ShortenedUrl.where(domain_name: request.server_name.downcase).
              order(created_at: :desc).page(params[:page])
  end

  def new
    @url = Shortener::ShortenedUrl.new(domain_name: request.server_name.downcase)
  end

  def edit
  end

  def create
    
    urls = create_shortenURL(params['url'], params['unique_key'])
    
    @url = urls[:short_url]
    url = urls[:url]

    # This logic all really belongs in the Shortener::ShortenedUrl model.  This
    # ugliness seems to be a sign that we should fork that gem and extend it.
    if url.works?
      unless params['unique_key'].blank?
        if params['unique_key'] =~ /\A[a-zA-Z0-9]+\Z/
          if Shortener::ShortenedUrl.where(domain_name: request.server_name.downcase).
            where("lower(unique_key) = ?", params['unique_key'].downcase).exists?

            @url = Shortener::ShortenedUrl.new url: params['url'], domain_name: request.server_name.downcase
            @url.errors[:base] << 'That short code already exists.'
          else
            @url = Shortener::ShortenedUrl.generate(url.to_s)
            @url.unique_key = params['unique_key']
            @url.domain_name = request.server_name.downcase
            @url.save
          end
        else
          @url = Shortener::ShortenedUrl.new url: params['url'], domain_name: request.server_name.downcase
          @url.errors[:base] << 'Short codes can only include numbers and letters.'
        end
      else
        @url = Shortener::ShortenedUrl.generate(url.to_s)
        @url.domain_name = request.server_name.downcase
      end
    else
      @url = Shortener::ShortenedUrl.new url: params['url'], domain_name: request.server_name.downcase
      @url.errors[:base] << 'That URL doesn\'t seem to work.'
    end

    respond_to do |format|
      if url.works? and @url.errors.messages.empty?
        format.html { redirect_to @url }
        format.json { render :show, status: :created, location: @url }
      else
        format.html { render :new }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Short URL was successfully updated.' }
        format.json { render :show, status: :ok, location: @url }
      else
        format.html { render :edit }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  # find the real link for the shortened link key and redirect
  def expand
    debugger
    # only use the leading valid characters
    token = /^([#{Shortener.key_chars.join}]*).*/i.match(params[:id])[1]

    # pull the link out of the db
    url = Shortener::ShortenedUrl.where(domain_name: request.server_name.downcase).
            where("lower(unique_key) = ?", token.downcase).first

    if url
      # don't want to wait for the increment to happen, make it snappy!
      # this is the place to enhance the metrics captured
      # for the system. You could log the request origin
      # browser type, ip address etc.
      Thread.new do
        url.increment!(:use_count)
        ActiveRecord::Base.connection.close
      end
      # do a 301 redirect to the destination url
      redirect_to full_url(url), :status => :moved_permanently
    else
      # if we don't find the shortened link, redirect to the root
      # make this configurable in future versions
      redirect_to '/'
    end
  end

  private

  def set_url
    @url = Shortener::ShortenedUrl.where(domain_name: request.server_name.downcase).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def url_params
    params.permit(
      :url,
      :unique_key,
      :utm_source, :utm_medium, :utm_term, :utm_content, :utm_name
    )
  end

end
