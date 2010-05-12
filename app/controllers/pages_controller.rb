class PagesController < ApplicationController
  resource_controller
  
  actions :show
  
  caches_action :show
  
  #show.before { response.headers['Cache-Control'] = "public, max-age=6400" }
end
