class PlansController < ApplicationController
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  #show.before { response.headers['Cache-Control'] = "public, max-age=6400" }
end
