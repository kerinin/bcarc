class Admin::PlansController < Admin::BaseController
  cache_sweeper :project_sweeper

  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans
  end

  def new
    @project = Project.find(params[:project_id])
    @plan = @project.plans.build
  end

  def edit
    @project = Project.find(params[:project_id])
    @plan = @project.plans.find(params[:id])
  end

  def create
    @project = Project.find(params[:project_id])
    @plan = @project.plans.new(plan_params)
    @plan.save!
    redirect_to edit_admin_project_plan_path(@project,@plan)
  end

  def update
    @project = Project.find(params[:project_id])
    @plan = @project.find(params[:id])
    @plan.update!(plan_params)
    redirect_to edit_admin_project_plan_path(@project,@plan)
  end
  
  def destroy
    @project = Project.find(params[:project_id])
    @plan = @project.find(params[:id])
    @plan.destroy!
    redirect_to admin_project_plans_path(@project)
  end
  
  def sort
    @project = Project.find(params[:project_id])
    @project.plans.each do |p|
      p.position = params["list-items"].index(p.id.to_s)+1

      p.save
    end
    
    render :nothing => true
  end

  private

  def plan_params
    params.require(:plan).permit(
      :name, :position, :attachment, :project_id
    )
  end
end
