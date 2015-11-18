class Admin::TagsController < Admin::BaseController
  after_filter :expire_show, :only => [:update, :destroy]

  cache_sweeper :tag_sweeper
  
  def index
    @tags = Tag.all
  end

  def get
    @tag = Tag.find(params[:id])
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.save!
    redirect_to edit_admin_tag_path(@tag)
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update!(tag_params)
    redirect_to edit_admin_tag_path(@tag)
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy!
    redirect_to admin_tags_path
  end
  
  private
  
  def tag_params
    params.require(:tag).permit(:name)
  end

  def expire_show
    expire_fragment "show_tag_#{params[:id] || :all}_by_"
    expire_fragment "show_tag_#{params[:id] || :all}_by_chronology"
    expire_fragment "show_tag_#{params[:id] || :all}_by_popularity"
  end
  
  def collection
    @tags = Tag
  end
end
