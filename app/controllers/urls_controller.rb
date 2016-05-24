require 'url_validator'

class UrlsController < ApplicationController
  http_basic_authenticate_with name: Setting.value('name'), password: Setting.value('password'),
                                except: :expand
  skip_before_action :verify_authenticity_token
  before_action :load_domains
  before_action :set_url, only: [:show, :edit, :update]
  
  include ApplicationHelper
  include NewUrlHelper

  def index
    @urls = Shortener::ShortenedUrl
    if @current_domain
      @urls = @urls.where(domain_name: @current_domain)
    end
    if params[:query].present?
      @urls = @urls.where("unique_key iLIKE ?", "%#{params[:query]}%")
    end
    @urls = @urls.order(created_at: :desc).page(params[:page])
  end

  def new
    @url = Shortener::ShortenedUrl.new(domain_name: @request_domain)
  end

  def edit
  end

  def create
    url_to_shorten = params[:url]
    is_url_working = URLValidator.new(url: url_to_shorten).works?
    domains = params[:domain_name]
    unique_key = params[:unique_key]

    urls_with_errors = domains.map do |domain|
      url = Shortener::ShortenedUrl.new url_params
      if is_url_working
        if unique_key.present?
          if unique_key =~ /\A[a-zA-Z0-9]+\Z/
            if Shortener::ShortenedUrl.where(domain_name: domain).
                where("lower(unique_key) = ?", unique_key.downcase).exists?
              url.errors[:base] << "That short code already exists for #{domain}."
            end
          else
            url.errors[:base] << 'Short codes can only include numbers and letters.'
          end
        end
        url
      else
        url.errors[:base] << 'That URL doesn\'t seem to work.'
      end
    end.select do |url|
      url.errors.present?
    end

    respond_to do |format|
      if urls_with_errors.empty?
        urls = domains.map do |domain|
          url = Shortener::ShortenedUrl.create url: url_to_shorten
          url.unique_key = unique_key if unique_key.present?
          url.domain_name = domain
          url.save
          url
        end
        format.html { redirect_to root_url }
        format.json { render :index, status: :created, location: urls }
      else
        @url = urls_with_errors.first
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
    url = Shortener::ShortenedUrl.where(domain_name: @request_domain).
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

  def load_domains
    @current_domain = session[:domain_name]
    @request_domain = request.server_name.downcase
    @domains = Shortener::ShortenedUrl.select(:domain_name).where("domain_name is not null").
                distinct(:domain_name).map(&:domain_name)
    @domains << @request_domain unless @domains.include?(@request_domain)
  end

end
