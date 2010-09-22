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
    
    should_route :get, 'Page/page_id', :controller => :pages, :action => :show, :id => 'page_id', :locale => :en

    context "on GET to :show" do
      setup do
        get :show, :id => @page1.to_param
      end
      should_respond_with :success
      should_assign_to :tags
    end
    
    context "on GET to :show with legacy URL" do
      setup do
        previous_param = @page1.to_param
        
        @page1.name = 'New Name'
        @page1.save!
        
        get :show, :id => previous_param
      end
      should_respond_with :success
      
      should "find the page" do
        assert assigns['page'] == @page1
      end
    end
  end
end
