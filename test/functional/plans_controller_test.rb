require File.dirname(__FILE__) + '/../test_helper'

class PlansControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = Factory :project, :thumbnail => Factory(:image)

      @plan1 = Factory :plan, :project => @project
      @plan2 = Factory :plan, :project => @project
            
      @image1 = Factory :image, :project => @project
      @image2 = Factory :image, :project => @project
      
      @video1 = Factory :video, :project => @project
      @video2 = Factory :video, :project => @project
    end
    
    teardown do
      Project.delete_all
      Image.delete_all
      Video.delete_all
      Plan.delete_all
    end
    
    should_route :get, 'Project/project_id/plans/plan_id', :controller => :plans, :action => :show, :project_id => 'project_id', :id => 'plan_id', :locale => :en

    context "on GET to :show from project" do
      setup do
        get :show, :project_id => @project.to_param, :id => @plan1.to_param
      end
      should_respond_with :success
      should_assign_to :tags
    end
  end
end
