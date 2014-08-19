class NewUrlController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  include NewUrlHelper  
  
  def create
    
    @url = Shortener::ShortenedUrl.generate('')
    url  = ""

    if valid_data
      
      if params['unique_key'].nil? || params['unique_key'].blank?
        o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
        params['unique_key'] = (0...5).map { o[rand(o.length)] }.join
      end
    
      urls = create_shortenURL(params['url'], params['unique_key'])
      @url = urls[:short_url]
      url  = urls[:url]
    
    end
    
    respond_to do |format|
      if @url.errors.messages.empty? and url.works?
        format.json { render json: { status: "created", location: @url }, status: 200 }
      else
        format.json { render json: { status: "error", message: @url.errors }, status: :unprocessable_entity }
      end
    end
  end
     
  def valid_data
    
    if params.key?(:url).nil? || params['url'].blank?
      return false
    end

    return true
  end

end