class Admin::ImagesController < Admin::BaseController
  
  resource_controller
  
  belongs_to :project
  
  actions :all
  
  create.wants.html { redirect_to edit_admin_project_image_path(@project,@image) }
  update.wants.html { redirect_to edit_admin_project_image_path(@project,@image) }
  destroy.wants.html { redirect_to admin_project_images_path(@project) }

  def sort
    @project = Project.find_by_param(params[:id])
    @project.images.each do |i|
      i.position = params["image-list"].index(i.id.to_s)+1

      i.save
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
