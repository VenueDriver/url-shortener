module ApplicationHelper

  def hostname
    request.server_name +
      (request.server_port.nil? ? '' : ":#{request.server_port}")
  end

end
