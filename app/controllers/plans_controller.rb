class PlansController < ApplicationController
  resource_controller
  
  actions :only => :show
end
