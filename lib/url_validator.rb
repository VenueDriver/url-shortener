require 'open-uri'

class URLValidator

  def initialize(url: nil)
    begin
      @url = normalize url: url
    rescue # Recover from totally broken URLs
    end
  end

  def works?
    begin # check header response
      open URI.parse(@url)
      return true
    rescue # Recover on DNS failures..
      return false
    end
    false
  end

  def to_s
    @url
  end

  private

  def normalize(url: nil)
    protocol_string = "http://"
    has_protocol = Regexp.new('\Ahttp:\/\/|\Ahttps:\/\/', Regexp::IGNORECASE)

    return nil if url.blank?
    url = protocol_string + url.strip unless url =~ has_protocol
    URI.parse(url).normalize.to_s
  end

end