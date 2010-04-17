class VideosController < ApplicationController
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  show.before do
    @project = @video.project
    unless @video == @project.videos.last
      @next = @project.videos[ @project.videos.index(@video) + 1]
    end
    
    if @video == @project.videos.first
      if @project.images.count
        @prev = @project.images.last
      end
    else
      @prev = @project.videos[ @project.videos.index(@video) - 1]
    end
  end
  
  private
  
  def object
    @object ||= end_of_association_chain.find_by_param!(param) unless param.nil?
    @object
  end
  
  def parent_object
    parent? && !parent_singleton? ? parent_model.find_by_param!(parent_param) : nil
  end
end
