class PagesController < ApplicationController
  #resource_controller
  
  #actions :show
  
  caches_action :show
  
  #show.before { response.headers['Cache-Control'] = "public, max-age=600" }
  
  def show
    @page = Page.find(params[:id])
    
    response.headers['Cache-Control'] = "public, max-age=600"
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
