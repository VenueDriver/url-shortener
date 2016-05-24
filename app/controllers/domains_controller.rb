class DomainsController < ApplicationController

  def switch
    session[:domain_name] = params[:domain_name]
    redirect_to root_url
  end

end
