class PlansController < ApplicationController
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  caches_action :show, :cache_path => Proc.new { |c| c.params.unshift( read_fragment("project_#{params[:project_id]}") ).delete_if { |k,v| k.starts_with?('utm_') } }
  cache_sweeper :project_sweeper
  
  #show.before { response.headers['Cache-Control'] = "public, max-age=6400" }
end
