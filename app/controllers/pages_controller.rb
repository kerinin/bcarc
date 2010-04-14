class PagesController < ApplicationController
  resource_controller
  
  actions :only => :show
end
