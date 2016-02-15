module ApplicationHelper

  def domain_name
    request.server_name
  end

  def active_if(action: nil)
    if action.class.eql? Array
      'active' if action.any? {|action| action.eql? params[:action] }
    else
      'active' if params[:action].eql? action
    end
  end

  def full_url(short_url)
    uri = URI.parse(short_url.url)
    utm_parameters =
      [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_name].
        reject{|utm_param| short_url.read_attribute(utm_param).blank?}.
        map{|utm_param| [utm_param, CGI.escape(short_url.read_attribute(utm_param))].join '='}.
        join('&')
    query = [uri.query, utm_parameters].reject{|string| string.blank?}.join('&')
    uri.query = query unless query.blank?
    uri.to_s
  end

  def condensed_url(short_url)
    "#{short_url.domain_name}/#{short_url.unique_key}"
  end

  def valid_condensed_url(short_url)
    'http://' + condensed_url(short_url)
  end

end
