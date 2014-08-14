module NewUrlHelper

  def create_shortenURL(params_url,params_unique)
  
  	url = URLValidator.new(url: params_url)

    # This logic all really belongs in the Shortener::ShortenedUrl model.  This
    # ugliness seems to be a sign that we should fork that gem and extend it.
    if url.works?
      unless params_unique.blank?
        if params_unique =~ /\A[a-zA-Z0-9\-]+\Z/
          unless Shortener::ShortenedUrl.where("lower(unique_key) = ?", params_unique.downcase).exists?
            short_url = Shortener::ShortenedUrl.generate(url.to_s)
            short_url.unique_key = params_unique
            short_url.save
          else
            short_url = Shortener::ShortenedUrl.new url: params_url
            short_url.errors[:base] << 'That short code already exists.'
          end
        else
          short_url = Shortener::ShortenedUrl.new url: params_url
          short_url.errors[:base] << 'Short codes can only include numbers, letters, and "-".'
        end
      else
        short_url = Shortener::ShortenedUrl.generate(url.to_s)
      end
    else
      short_url = Shortener::ShortenedUrl.new url: params_url
      short_url.errors[:base] << 'That URL doesn\'t seem to work.'
    end

    return { url: url, short_url: short_url }
  end    

end 