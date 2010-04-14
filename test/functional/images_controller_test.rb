require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
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
    
    should_route 'Projects/project_id/images/image_id', :controller => :images, :project_id => 'project_id', :id => 'image_id'

    context "on GET to :show from project" do
      setup do
        get :show, :project_id => @project.to_param, :id => @image1.to_param
      end
      should_respond_with :success
    end
  end
end
