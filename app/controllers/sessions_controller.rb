class SessionsController < ApplicationController
  def new
    respond_to do |format|
      format.html {
        render :new, :layout => nil
      }
    end
  end
  
  def create
    session[:auth] = request.env['omniauth.auth']
    redirect_to request.env['omniauth.origin'] || '/admin'
  end
  
  def failure
    render :text => 'You must log in using your Bercy Chen google apps to use this page'
  end
end