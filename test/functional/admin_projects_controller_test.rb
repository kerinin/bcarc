require File.dirname(__FILE__) + '/../test_helper'

class Admin::ProjectsControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = Factory :project
    end

    teardown do
      Project.delete_all
    end
        
    context "on POST to :create" do
      setup do
        post :create, :project => { :name => 'New Project', :description => 'New Description' }
      end
      should_assign_to :project
      should_redirect_to('edit project') { edit_admin_project_path(assigns['project']) }
      should_set_the_flash_to "Successfully created!"
      
      should "create a new project" do
        assert_equal 1, Project.find_all_by_name('New Project').count
      end
    end
    
    context "on PUT to :update" do
      setup do
        put :update, :id => @project.id, :project => { :name => 'Changed Name', :description => 'Changed Description' }
      end
      should_assign_to :project
      should_redirect_to('edit project') {edit_admin_project_path(assigns['project'])}
      
      should "update the project" do
        assert_equal 'Changed Name', assigns['project'].name
        assert_equal 'Changed Description', assigns['project'].description
      end
    end
    
    context "on GET to :destroy" do
      setup do
        get :destroy, :id => @project.id
      end
      should_redirect_to('project index') {admin_projects_path}
      
      should "delete the video" do
        assert !Project.exists?( @project )
      end
    end
  end
end
