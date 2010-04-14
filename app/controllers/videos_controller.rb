class VideosController < ApplicationController
  resource_controller
  
  belongs_to :project
  
  actions :show
end
