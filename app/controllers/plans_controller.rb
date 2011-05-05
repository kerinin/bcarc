class PlansController < ApplicationController
  #resource_controller
  
  #belongs_to :project
  
  #actions :show
  
  caches_action :show, :cache_path => Proc.new { |c| c.params.merge( {:version => c.read_fragment("project_#{c.params[:project_id]}")} ).delete_if { |k,v| k.starts_with?('utm_') } }
  
  #show.before { response.headers['Cache-Control'] = "public, max-age=600" }
  
  def show
    @plan = Plan.find(params[:id])
    @project = @plan.project
    
    response.headers['Cache-Control'] = "public, max-age=600"
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
