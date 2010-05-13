class Admin::VideosController < Admin::BaseController
  resource_controller
  
  belongs_to :project
  
  actions :all
  
  cache_sweeper :project_sweeper
    
  create.wants.html { redirect_to edit_admin_project_video_path(@project,@video) }
  update.wants.html { redirect_to edit_admin_project_video_path(@project,@video) }
  destroy.wants.html { redirect_to admin_project_videos_path(@project) }

  def sort
    @project = Project.find_by_param(params[:id])
    @project.videos.each do |i|
      i.position = params["video-list"].index(i.id.to_s)+1

      i.save
    end
  end
end
