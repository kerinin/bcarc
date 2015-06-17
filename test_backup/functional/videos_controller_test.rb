require File.dirname(__FILE__) + '/../test_helper'

class VideosControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @firstProject = FactoryGirl.create :project, :thumbnail => FactoryGirl.create(:image)
      @project = FactoryGirl.create :project, :thumbnail => FactoryGirl.create(:image), :name => 'Original Name'
      @lastProject = FactoryGirl.create :project, :thumbnail => FactoryGirl.create(:image)
      
      @image1 = FactoryGirl.create :image, :project => @project
      @image2 = FactoryGirl.create :image, :project => @project
      
      @video1 = FactoryGirl.create :video, :project => @project
      @video2 = FactoryGirl.create :video, :project => @project
    end
    
    teardown do
      Project.delete_all
      Image.delete_all
      Video.delete_all
    end

    should route( :get, 'Project/project_id/videos/video_id').to( :controller => :videos, :action => :show, :project_id => 'project_id', :id => 'video_id')

    context "on GET to :show from project" do
      setup do
        get :show, :project_id => @project.to_param, :id => @video1.to_param
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
        
        get :show, :project_id => previous_param, :id => @video1.to_param
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
        
        get :show, :project_id => second_param, :id => @video1.to_param
      end
      should respond_with( :success)
      
      should "find the project from second" do
        assert assigns['project'] == @project
      end
    end
  end
end
