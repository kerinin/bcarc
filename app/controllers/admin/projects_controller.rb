class Admin::ProjectsController < Admin::BaseController
  after_filter :expire_show, :only => [:update, :destroy]
  after_filter :expire_thumbnails, :only => [:destroy]
  after_filter :expire_tags, :only => [:create, :update, :destroy]
  
  cache_sweeper :project_sweeper, :tag_sweeper
  
  def index
    @projects = Project.all
  end

  def get
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)
    @project.save!
    redirect_to edit_admin_project_path(@project)
  end

  def update
    @project = Project.find(params[:id])
    @project.update!(project_params)
    redirect_to edit_admin_project_path(@project)
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy!
    redirect_to admin_projects_path
  end
  
  private
  
  def project_params
    params.require(:project).permit(
      :name, :short, :date_completed, :description, :priority, :thumbnail_id,
      :latitude, :longitude, :address, :city, :state, :keywords, :show_map, :map_accuracy,
      :flickr_id, :has_tags, :has_webcam, :webcam_current_url, :webcam_ftp_dir, 
      :webcam_file_prefix
    )
  end

  def expire_show
    expire_fragment(:controller => 'projects', :action => 'show')
  end
  
  def expire_thumbnails
    expire_fragment "thumbnails_for_#{@project.id}"
  end
  
  def expire_tags
    @project.tags.each do |t|
      expire_fragment "show_tag_#{params[:id] || :all}_by_"
      expire_fragment "show_tag_#{params[:id] || :all}_by_chronology"
      expire_fragment "show_tag_#{params[:id] || :all}_by_popularity"
    end
  end
end
