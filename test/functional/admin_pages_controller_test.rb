require File.dirname(__FILE__) + '/../test_helper'

class Admin::PagesControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @page = Factory :page
    end

    teardown do
      Page.delete_all
    end
        
    context "on GET to :new" do
      setup do
        get :new
      end
      should respond_with( :success)
    end
    
    context "on POST to :create" do
      setup do
        post :create, :page => {:name => 'New Page', :content => 'New Content' }
      end
      should assign_to( :page)
      should redirect_to('edit page') {edit_admin_page_path(assigns['page'])}
      
      should "create a new page" do
        assert_equal 1, Page.find_all_by_name('New Page').count
      end
    end
    
    context "on PUT to :update" do
      setup do
        put :update, :id => @page.id, :page => { :name => 'Changed Name', :content => 'Changed Content' }
      end
      should assign_to( :page)
      should redirect_to('edit page') {edit_admin_page_path(assigns['page'])}
      
      should "update the page" do
        assert_equal 'Changed Name', assigns['page'].name
        assert_equal 'Changed Content', assigns['page'].content
      end
    end
    
    context "on GET to :destroy" do
      setup do
        get :destroy, :id => @page.id
      end
      should redirect_to('page index') {admin_pages_path}
      
      should "delete the page" do
        assert !Page.exists?( @page )
      end
    end
  end
end
