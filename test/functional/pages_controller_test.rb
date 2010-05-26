require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase
  
  context "Given data" do
    setup do
      @page1 = Factory :page
      @page2 = Factory :page
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
  end
end
