class Admin::VideosController < Admin::BaseController
  
  cache_sweeper :project_sweeper
    
  def index
    @project = Project.find(params[:project_id])
    @videos = @project.videos
  end

  def new
    @project = Project.find(params[:project_id])
    @video = @project.videos.build
  end

  def edit
    @project = Project.find(params[:project_id])
    @video = @project.videos.find(params[:id])
  end

  def create
    @project = Project.find(params[:project_id])
    @video = @project.videos.new(video_params)
    @video.save!
    redirect_to edit_admin_project_video_path(@project,@video)
  end

  def update
    @project = Project.find(params[:project_id])
    @video = @project.videos.find(params[:id])
    @video.update!(video_params)
    redirect_to edit_admin_project_video_path(@project,@video)
  end
  
  def destroy
    @project = Project.find(params[:project_id])
    @video = @project.videos.find(params[:id])
    @video.destroy!
    redirect_to admin_project_videos_path(@project)
  end
  
  def sort
    @project = Project.find(params[:project_id])
    @project.videos.each do |i|
      i.position = params["list-items"].index(i.id.to_s)+1

      i.save
    end
    
    render :nothing => true
  end

  private

  def video_params
    params.require(:video).permit(
      :name, :position, :description, :width, :height, :uri, :thumbnail, :project_id
    )
  end
end
