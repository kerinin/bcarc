require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = Factory :project, :thumbnail => Factory(:image)
      
      @image1 = Factory :image, :project => @project
      @image2 = Factory :image, :project => @project
      
      @video1 = Factory :video, :project => @project
      @video2 = Factory :video, :project => @project
    end
    
    teardown do
      Project.delete_all
      Image.delete_all
      Video.delete_all
    end
    
    should_route 'Projects/project_id', :controller => :projects, :id => 'project_id'

    context "on GET to :show" do
      setup do
        get :show, :id => @project.to_param
      end
      should_respond_with :success
    end
  end
end
