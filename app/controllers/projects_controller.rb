class ProjectsController < ApplicationController
  resource_controller
  
  actions :only => [:show, :index]
end
