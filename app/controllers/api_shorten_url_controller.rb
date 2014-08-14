class ApiShortenUrlController < ApplicationController
  include ApiShortenUrlHelper  
  
  def create
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts params.inspect

    if !(params['url'] && params['unique_key'])
      render json: {status: false} and return
    end

    puts params['url']
    puts params['unique_key']
    urls = create_shortenURL(params['url'], params['unique_key'])
    
    @url = urls[:short_url]
    url = urls[:url]

    respond_to do |format|
      if url.works? and @url.errors.messages.empty?
        format.json { render json:"created" , location: @url }
      else  
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # private

  # def restrict_params
  #   unless params['url'].blank? || params['unique_key'].blank?
  #     params.require(:setting).permit(:params['url'], :params['unique_key'])
  #   end
  # end   
end
