require 'url_validator'

class UrlsController < ApplicationController
  #http_basic_authenticate_with name: Setting.value('name'), password: Setting.value('password'),
  #  except: :expand
  skip_before_action :verify_authenticity_token
  before_action :set_url, only: [:show, :edit, :update]
  
  include ApplicationHelper
  include ApiShortenUrlHelper

  def index
    @urls = Shortener::ShortenedUrl.order(created_at: :desc).page(params[:page])
  end

  def new
    @url = Shortener::ShortenedUrl.new
  end

  def edit
  end

  def create

    urls = create_shortenURL(params['url'], params['unique_key'])
    
    @url = urls[:short_url]
    url = urls[:url]

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
    # only use the leading valid characters
    token = /^([#{Shortener.key_chars.join}]*).*/i.match(params[:id])[1]

    # pull the link out of the db
    url = Shortener::ShortenedUrl.where("lower(unique_key) = ?", token.downcase).first

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
    @url = Shortener::ShortenedUrl.find(params[:id])
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