class ApiShortenUrlController < ApplicationController
  include ApiShortenUrlHelper  
  
  def create

    @url = Shortener::ShortenedUrl.generate('')
    url  = ""

    if valid_data
      urls = create_shortenURL(params['url'], params['unique_key'])
      @url = urls[:short_url]
      url  = urls[:url]
    end

    respond_to do |format|
      if @url.errors.messages.empty? and url.works?
        format.json { render json: "created" , location: @url }
      else
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end
     
  def valid_data
    unless (params.key?(:unique_key) || params.key?(:url))      
      return false
    end

    if (params['unique_key'].blank? || params['url'].blank?)      
      return false
    end
    return true
  end

end