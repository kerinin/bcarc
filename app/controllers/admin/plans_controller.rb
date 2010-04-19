class Admin::PlansController < Admin::BaseController
  resource_controller
  
  belongs_to :project
  
  actions :all
  
  create.wants.html { redirect_to edit_admin_project_plan_path(@project,@plan) }
  update.wants.html { redirect_to edit_admin_project_plan_path(@project,@plan) }
  destroy.wants.html { redirect_to admin_project_plans_path(@project) }

  def sort
    @project = Project.find_by_param(params[:id])
    @project.plans.each do |p|
      p.position = params["plan-list"].index(p.id.to_s)+1

      p.save
    end
  end
    
  private
  
  def collection
    end_of_association_chain
  end
  
  def object
    @object ||= end_of_association_chain.find_by_param!(param) unless param.nil?
    @object
  end
  
  def parent_object
    parent? && !parent_singleton? ? parent_model.find_by_param!(parent_param) : nil
  end
end
