class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def handle_unverified_request
      true
  end
  
  def new
    respond_to do |format|
      format.html {
        render :new, :layout => nil
      }
    end
  end
  
  def create
    if request.env['omniauth.auth']['user_info']['email'].end_with?( '@bcarc.com')
      session[:auth] = request.env['omniauth.auth']
      redirect_to request.env['omniauth.origin'] || '/admin'
    else
      redirect_to '/auth/failure'
    end
  end
  
  def failure
    respond_to do |format|
      format.html {
        render :failure, :layout => nil
      }
    end
  end
end