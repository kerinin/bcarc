require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase
  
  context "Given data" do
    setup do
      @page1 = Factory :page, :name => 'Test Page'
      @page2 = Factory :page, :name => 'Test Page2'
      
      @tag = Factory :tag
    end
    
    teardown do
      Page.delete_all
    end
    
    should route( :get, 'Page/page_id').to( :controller => :pages, :action => :show, :id => 'page_id')

    context "on GET to :show" do
      setup do
        get :show, :id => @page1.to_param
      end
      should respond_with( :success)
      should assign_to( :tags)
    end
    
    context "on GET to :show with legacy URLs" do
      setup do
        previous_param = @page1.to_param
        
        @page1.name = 'New Name 1'
        @page1.save!
        second_param = @page1.to_param
        
        @page1.name = 'New Name 2'
        @page1.save!
        
        get :show, :id => previous_param
      end
      should respond_with( :success)
      
      should "find the page from original" do
        assert assigns['page'] == @page1
      end
    end
    
    context "on GET to :show with another legacy URL" do
      setup do
        previous_param = @page1.to_param
        
        @page1.name = 'New Name 1'
        @page1.save!
        second_param = @page1.to_param
        
        @page1.name = 'New Name 2'
        @page1.save!
        
        get :show, :id => second_param
      end
      should respond_with( :success)
      
      should "find the page from second" do
        assert assigns['page'] == @page1
      end
    end
  end
end
