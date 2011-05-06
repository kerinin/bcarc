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
    
    should route( :get, 'Project/project_id/plans/plan_id').to( :controller => :plans, :action => :show, :project_id => 'project_id', :id => 'plan_id')

    context "on GET to :show from project" do
      setup do
        get :show, :project_id => @project.to_param, :id => @plan1.to_param
      end
      should respond_with( :success)
      should assign_to( :tags)
    end
    
    context "on GET to :show from project with legacy URLs" do
      setup do
        previous_param = @project.to_param
        
        @project.name = 'New Name 1'
        @project.save!
        second_param = @project.to_param
        
        @project.name = 'New Name 2'
        @project.save!
        
        get :show, :project_id => previous_param, :id => @plan1.to_param
      end
      should respond_with( :success)
      
      should "find the project from original" do
        assert assigns['project'] == @project
      end
    end
    
    context "on GET to :show from project with another legacy URL" do
      setup do
        previous_param = @project.to_param
        
        @project.name = 'New Name 1'
        @project.save!
        second_param = @project.to_param
        
        @project.name = 'New Name 2'
        @project.save!
        
        get :show, :project_id => second_param, :id => @plan1.to_param
      end
      should respond_with( :success)
      
      should "find the project from second" do
        assert assigns['project'] == @project
      end
    end
  end
end
