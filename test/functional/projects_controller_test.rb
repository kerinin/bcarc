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
    
    context "on GET to :show w/ preferred languages" do
      setup do
        @request.env[ "ACCEPT_LANGUAGE" ] = 'es, wtf, en'
        get :show, :id => @project.to_param
      end
      
      should "include the language switcher for recognized languages" do
        assert_select '#language_switcher', :text => /español/
        assert_select '#language_switcher', :text => /english/
      end
      
      should "highlight the current language" do
        assert_select '#language_switcher .current', :text => /english/
      end
      
      should "not include translated languages not in the preferred languages" do
        assert_select '#language_switcher', {:count => 0, :text => /français/}
      end
    end
    
    context "on GET to :index" do
      setup do
        get :index
      end
      should_respond_with :success
      should_assign_to :tags
    end
    
    context "on GET to :index with preferred locales" do
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
