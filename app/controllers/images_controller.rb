class ImagesController < ApplicationController
  
  resource_controller
  
  belongs_to :project
  
  actions :only => :show
end
