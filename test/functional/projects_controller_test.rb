require File.dirname(__FILE__) + '/../test_helper'

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
    
    should_route :get, '', :controller => :projects, :action => :index, :locale => :en
    #should_route :get, 'projects', :controller => :projects, :action => :index
    
    should_route :get, 'Project/project_id', :controller => :projects, :action => :show, :id => 'project_id', :locale => :en

    context "on GET to :show" do
      setup do
        get :show, :id => @project.to_param
      end
      should_respond_with :success
      should_assign_to :tags
    end
    
    context "on GET to :index" do
      setup do
        get :index
      end
      should_respond_with :success
      should_assign_to :tags
    end
    
    context "on GET to :index with locale" do
      setup do
        get :index, :locale => 'zh'
      end
      
      should "set the locale to ZH" do
        assert_equal :zh, I18n.locale
      end
    end
  end
end
