class VideosController < ApplicationController
  resource_controller
  
  actions :only => :show
end
