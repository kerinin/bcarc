class ProjectsController < ApplicationController
  resource_controller
  
  actions :show, :index
  
  show.before do
    if @project.images.count > 1
      @next = @project.images[1]
    elsif @project.videos.count
      @next = @project.videos[0]
    end
  end
  
  private
  
  def object
    @object ||= end_of_association_chain.find_by_permalink!(param) unless param.nil?
    @object
  end
end
