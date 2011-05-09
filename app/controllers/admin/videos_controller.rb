class Admin::VideosController < Admin::BaseController
  #resource_controller
  
  belongs_to :project
  
  #actions :all
  
  cache_sweeper :project_sweeper
    
  #create.wants.html { redirect_to edit_admin_project_video_path(@project,@video) }
  #update.wants.html { redirect_to edit_admin_project_video_path(@project,@video) }
  #destroy.wants.html { redirect_to admin_project_videos_path(@project) }
  
  def create
    create!{ edit_admin_project_video_path(@project,@video) }
  end

  def update
    update!{ edit_admin_project_video_path(@project,@video) }
  end
  
  def destroy
    destroy! do |format|
      format.html { redirect_to admin_project_videos_path(@project) }
    end
  end
  
  def sort
    @project = Project.find(params[:project_id])
    @project.videos.each do |i|
      i.position = params["video-list"].index(i.id.to_s)+1

      i.save
    end
    
    render :nothing => true
  end
end
