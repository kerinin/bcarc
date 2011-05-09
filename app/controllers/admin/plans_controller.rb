class Admin::PlansController < Admin::BaseController
  #resource_controller
  
  belongs_to :project
  
  #actions :all

  cache_sweeper :project_sweeper
  
  #create.wants.html { redirect_to edit_admin_project_plan_path(@project,@plan) }
  #update.wants.html { redirect_to edit_admin_project_plan_path(@project,@plan) }
  #destroy.wants.html { redirect_to admin_project_plans_path(@project) }

  def create
    create!{ edit_admin_project_plan_path(@project,@plan) }
  end

  def update
    update!{ edit_admin_project_plan_path(@project,@plan) }
  end
  
  def destroy
    destroy! do |format|
      format.html { redirect_to admin_project_plans_path(@project) }
    end
  end
  
  def sort
    @project = Project.find(params[:project_id])
    @project.plans.each do |p|
      p.position = params["plan-list"].index(p.id.to_s)+1

      p.save
    end
    
    render :nothing => true
  end
end
