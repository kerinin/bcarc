class PagesController < ApplicationController
  resource_controller
  
  actions :show
  
  caches_action :show
  cache_sweeper :page_sweeper
  
  #show.before { response.headers['Cache-Control'] = "public, max-age=6400" }
end
