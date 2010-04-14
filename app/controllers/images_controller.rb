class ImagesController < ApplicationController
  
  resource_controller
  
  actions :only => :show
end
