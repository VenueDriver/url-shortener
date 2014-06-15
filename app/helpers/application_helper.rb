module ApplicationHelper

  def hostname
    request.server_name.titlecase +
      (request.server_port.nil? ? '' : ":#{request.server_port}")
  end

  def active_if(action: nil)
    if action.class.eql? Array
      'active' if action.any? {|action| action.eql? params[:action] }
    else
      'active' if params[:action].eql? action
    end
  end

end
