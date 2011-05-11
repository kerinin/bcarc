class Admin::VideosController < Admin::BaseController
  
  belongs_to :project
  
  cache_sweeper :project_sweeper
    
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
