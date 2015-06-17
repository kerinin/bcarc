require File.dirname(__FILE__) + '/../test_helper'

class ImagesControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = FactoryGirl.create :project
      
      @image1 = FactoryGirl.create :image, :project => @project, :position => 1
      @image2 = FactoryGirl.create :image, :project => @project, :position => 2
      @image3 = FactoryGirl.create :image, :project => @project, :position => 3
      @deleted_image = FactoryGirl.create :image, :project => @project
      @deleted_image.destroy
      
      @video1 = FactoryGirl.create :video, :project => @project
      @video2 = FactoryGirl.create :video, :project => @project
      
      @project.thumbnail = @image1
      @project.save!
    end
    
    teardown do
      Project.delete_all
      Image.delete_all
      Video.delete_all
    end
    
    should route( :get, '/Project/:project_id/Images/:id').to( :controller => :images, :action => :show, :project_id => ':project_id', :id => ':id')
    should route( :get, '/zh/Project/:project_id/Images/:id').to( :controller => :images, :action => :show, :project_id => ':project_id', :id => ':id', :locale => :zh)

    context "on GET to :show from project" do
      setup do
        get :show, :project_id => @project.to_param, :id => @image2.to_param
      end
      should respond_with( :success)
      should assign_to( :tags)
      
      should "set default locale" do
        assert_equal :en, I18n.locale
      end
      
      should "assign the image" do
        assert assigns['image'] == @image2
      end
      
      should "highlight current image" do
        assert_select "a.current_image[href*=#{project_image_path(@project, @image2)}]"
      end
    end
    
    context "on GET to :show from project for deleted image" do
      setup do
        get :show, :project_id => @project.to_param, :id => @deleted_image.to_param
      end
      should respond_with( :success)
      should assign_to( :image )
      should assign_to( :next)
      should_not assign_to( :prev)
      
      should "assign the image" do
        assert_equal @deleted_image, assigns['image']
      end
      
      should "assign second project image to 'next'" do
        assert_equal @image2, assigns['next']
      end
    end
    
    context "on GET to :show from project with legacy URLs" do
      setup do
        previous_param = @project.to_param
        
        @project.name = 'New Name 1'
        @project.save!
        second_param = @project.to_param
        
        @project.name = 'New Name 2'
        @project.save!
        
        get :show, :project_id => previous_param, :id => @image1.to_param
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
        
        get :show, :project_id => second_param, :id => @image1.to_param
      end
      should respond_with( :success)
      
      should "find the project from second" do
        assert assigns['project'] == @project
      end
    end
  end
end
