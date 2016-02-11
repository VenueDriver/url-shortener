class DomainsController < ApplicationController

  def switch
    session[:domain_name] = params[:domain_name]
    redirect_to root_url, notice: "Switch domain to #{session[:domain_name]}"
  end

end
