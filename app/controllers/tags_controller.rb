class TagsController < ApplicationController
  resource_controller
  
  actions :only => :show
end
