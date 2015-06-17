require File.dirname(__FILE__) + '/../test_helper'

class ProjectsControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @completed = 1.year.ago
      @tag = FactoryGirl.create :tag
      
      @project = FactoryGirl.create :project, 
        :name => 'Test Project',
        :description => 'Project Description',
        :short => 'Short Description',
        :date_completed => @completed,
        :address => '100 5th Street',
        :city => 'San Francisco',
        :state => 'CA',
        :priority => 1,
        :thumbnail => FactoryGirl.create(:image),
        :webcam_current_url => '/foo'
          
      @project.tags << @tag
      @inactive_project = FactoryGirl.create :project, :priority => 1
      
      @image1 = FactoryGirl.create :image, :project => @project
      @image2 = FactoryGirl.create :image, :project => @project
      
      @video1 = FactoryGirl.create :video, :project => @project
      @video2 = FactoryGirl.create :video, :project => @project
      
      @plan1 = FactoryGirl.create :plan, :project => @project
      @plan2 = FactoryGirl.create :plan, :project => @project
    end
    
    teardown do
      Project.delete_all
      Image.delete_all
      Video.delete_all
    end
    
    should route( :get, '').to( :controller => :projects, :action => :index)
    
    should route( :get, 'Project/project_id').to( :controller => :projects, :action => :show, :id => 'project_id')

    context "on GET to :show" do
      setup do
        get :show, :id => @project.to_param
      end
      should respond_with( :success)
      should assign_to( :tags)
      
      should "not show link to map view when no lat/lon" do
        assert_select 'a', {:count =>0, :text => 'map'}
      end
    end
    
    context "on GET to :map" do
      setup do 
        @project.update_attributes( :show_map => true, :latitude => 0, :longitude => 0, :map_accuracy => 8)
        get :map, :id => @project.to_param
      end
      
      should respond_with(:success)
    end
    
    context "on GET to :webcam" do
      setup do
        get :webcam, :id => @project.to_param
      end
      
      should respond_with(:success)
    end
    
    context "on GET to :show with legacy URLs" do
      setup do
        previous_param = @project.to_param
        
        @project.name = 'New Name 1'
        @project.save!
        second_param = @project.to_param
        
        @project.name = 'New Name 2'
        @project.save!
        
        get :show, :id => previous_param
      end
      should respond_with( :success)
      
      should "find the project from original" do
        assert assigns['project'] == @project
      end
    end
    
    context "on GET to :show with another legacy URL" do
      setup do
        previous_param = @project.to_param
        
        @project.name = 'New Name 1'
        @project.save!
        second_param = @project.to_param
        
        @project.name = 'New Name 2'
        @project.save!
        
        get :show, :id => second_param
      end
      should respond_with( :success)
      
      should "find the project from second" do
        assert assigns['project'] == @project
      end
    end
  
    context "on GET to :show w/ preferred languages" do
      setup do
        @request.env['HTTP_ACCEPT_LANGUAGE'] = 'es,en,wtf'
        get :show, :id => @project.to_param
      end
      
      should "set the request language" do
        assert_equal 'es,en,wtf', @request.env['HTTP_ACCEPT_LANGUAGE']
      end
            
      should "set the languages" do
        assert_contains @request.user_preferred_languages, 'es'
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
      should respond_with( :success)
      should assign_to( :tags)
      
      should "include active projects" do
        assert_contains assigns['projects'], @project
      end
      
      should "not include inactive projects" do
        assert_does_not_contain assigns['projects'], @inactive_project
      end
    end
    
    context "on GET to :index with locale" do
      setup do
        get :index, :locale => 'es'
      end
      
      should "set the locale to ES" do
        assert_equal :es, I18n.locale
      end
      
      should "include the language switcher for recognized languages" do
        assert_select '#language_switcher', :text => /español/
        assert_select '#language_switcher', :text => /english/
      end
      
      should "highlight the current language" do
        assert_select '#language_switcher .current', :text => /español/
      end
    end
  end
  
  context "Given project w/ location, show_map -> false" do
    setup do
      @project = FactoryGirl.create :project, :thumbnail => FactoryGirl.create(:image), :latitude => 90, :longitude => 90, :show_map => false, :city => 'Austin'
    end
    
    context "on GET to :show" do
      setup do
        get :show, :id => @project.to_param
      end
      should respond_with( :success)
      
      should "not show link to map" do
        assert_select 'a', {:count =>0, :text => 'map'}
      end
    end   
  end
  
  context "Given project w/ location, show_map -> true" do
    setup do
      @project = FactoryGirl.create :project, :thumbnail => FactoryGirl.create(:image), :show_map => true, :city => 'Austin'
    end
    
    context "on GET to :show" do
      setup do
        get :show, :id => @project.to_param
      end
      should respond_with( :success)
      
      should "show link to map" do
        assert_select 'a', {:count =>1, :text => 'map'}
      end
    end   
    
    context "on GET to :show.kml" do
      setup do
        get :show, :id => @project.to_param, :format => :kml
      end
      
      should respond_with(:success)
      should render_template('show')
    end
  end
end
