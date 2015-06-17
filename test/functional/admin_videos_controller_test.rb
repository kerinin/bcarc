require File.dirname(__FILE__) + '/../test_helper'

class Admin::VideosControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = FactoryGirl.create :project
      @video = FactoryGirl.create :video, :project => @project
      @video2 = FactoryGirl.create :video, :project => @project
      @video3 = FactoryGirl.create :video, :project => @project
      @video4 = FactoryGirl.create :video, :project => @project
    end

    teardown do
      Project.delete_all
      Video.delete_all
    end
        
    context "on GET to :new from project" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should respond_with( :success)
    end
    
    context "on POST to :create" do
      setup do
        post :create, :project_id => @project.to_param, :video => { :name => 'New Video', :uri => 'http://vimeo.com/8063014' }
      end
      should assign_to( :video)
      should redirect_to('edit video') { edit_admin_project_video_path(@project, assigns['video']) }
      should set_the_flash.to( "Video was successfully created.")
      
      should "create a new video" do
        assert_equal 1, Video.find_all_by_name('New Video').count
      end
    end
    
    context "on PUT to :update" do
      setup do
        put :update, :project_id => @project.to_param, :id => @video.id, :video => { :name => 'Changed Name' }
      end
      should assign_to( :video)
      should redirect_to('edit video') {edit_admin_project_video_path(@project, assigns['video'])}
      
      should "update the video" do
        assert_equal 'Changed Name', assigns['video'].name
      end
    end
    
    context "on GET to :destroy" do
      setup do
        get :destroy, :project_id => @project.to_param, :id => @video.id
      end
      should redirect_to('video index') {admin_project_videos_path( @project )}
      
      should "delete the video" do
        assert !Video.exists?( @video )
      end
    end
    
    context "on GET to :sort" do
      setup do
        get :sort, :project_id => @project.to_param, 'video-list' => [@video3.id.to_s, @video2.id.to_s, @video4.id.to_s, @video.id.to_s]
      end

      should respond_with(:success)

      should "update video order" do
        assert_equal @video3, @project.videos[0]
        assert_equal @video2, @project.videos[1]
        assert_equal @video4, @project.videos[2]
        assert_equal @video, @project.videos[3]
      end
    end
  end
end
