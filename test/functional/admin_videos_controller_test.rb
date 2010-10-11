require File.dirname(__FILE__) + '/../test_helper'

class Admin::VideosControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = Factory :project
      @video = Factory :video, :project => @project
    end

    teardown do
      Project.delete_all
      Video.delete_all
    end
        
    context "on GET to :new from project" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should_respond_with :success
    end
    
    context "on POST to :create" do
      setup do
        post :create, :project_id => @project.to_param, :video => { :name => 'New Video', :uri => 'http://vimeo.com/8063014' }
      end
      should_assign_to :video
      should_redirect_to('edit video') { edit_admin_project_video_path(@project, assigns['video']) }
      should_set_the_flash_to "Successfully created!"
      
      should "create a new video" do
        assert_equal 1, Video.find_all_by_name('New Video').count
      end
    end
    
    context "on PUT to :update" do
      setup do
        put :update, :project_id => @project.to_param, :id => @video.id, :video => { :name => 'Changed Name' }
      end
      should_assign_to :video
      should_redirect_to('edit video') {edit_admin_project_video_path(@project, assigns['video'])}
      
      should "update the video" do
        assert_equal 'Changed Name', assigns['video'].name
      end
    end
    
    context "on GET to :destroy" do
      setup do
        get :destroy, :project_id => @project.to_param, :id => @video.id
      end
      should_redirect_to('video index') {admin_project_videos_path( @project )}
      
      should "delete the video" do
        assert !Video.exists?( @video )
      end
    end
  end
end
