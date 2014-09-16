class NewUrlController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  include NewUrlHelper
  include ApplicationHelper
  
  def create
    
    @url = Shortener::ShortenedUrl.generate('')
    url  = ""

    if valid_data
      
      if params['unique_key'].nil? || params['unique_key'].blank?
          begin        
            o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
            params['unique_key'] = (0...5).map { o[rand(o.length)] }.join
          end while Shortener::ShortenedUrl.where("lower(unique_key) = ?", params['unique_key'].downcase).exists?
      end
    
      urls = create_shortenURL(params['url'], params['unique_key'])
      @url = urls[:short_url]
      url  = urls[:url]
    
    end
    
    respond_to do |format|
      if @url.errors.messages.empty? and url.works?
        short_url = condensed_url @url
        format.json { render json: { status: "created", location: @url, affiliate_code_staff: params["affiliate_code_staff"] , event_id: params["event_id"], short_url: short_url }, status: 200 }
      else
        format.json { render json: { status: "error", message: @url.errors }, status: :unprocessable_entity }
      end
    end
  end

  def api_update
    respond_to do |format|
      format.json { render json: { status: "success", message: Time.now.strftime("%Y/%m/%d %H:%M:%S") }, status: 200}
    end
  end

  def valid_data
    
    if params.key?(:url).nil? || params['url'].blank?
      return false
    end

    return true
  end

end