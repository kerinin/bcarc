class ImagesController < ApplicationController
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  show.before do
    @project = @image.project
    if @image == @project.images.last
      if @project.videos.count
        @next = @project.videos.first
      end
    else
      @next = @project.images[ @project.images.index(@image) + 1]
    end
    
    unless @image == @project.images.first
      @prev = @project.images[ @project.images.index(@image) - 1]
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
