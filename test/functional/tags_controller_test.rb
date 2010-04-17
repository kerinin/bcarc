require File.dirname(__FILE__) + '/../test_helper'

class TagsControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @tag1 = Factory :tag
      @tag2 = Factory :tag
      
      @project1 = Factory :project, :tags => [@tag1, @tag2], :date_completed => 3.month.ago, :priority => 2
      @project2 = Factory :project, :tags => [@tag1], :date_completed => 1.months.ago, :priority => 1
      @project3 = Factory :project, :tags => [@tag1], :date_completed => 2.months.ago, :priority => 3
      @project4 = Factory :project, :tags => [@tag2]
    end
    
    teardown do
      Project.delete_all
      Tag.delete_all
    end
    
    should_route :get, 'tags/tag_id', :controller => :tags, :action => :show, :id => 'tag_id'
    context "on GET to :show" do
      setup do
        get :show, :id => @tag1.to_param
      end
      should_respond_with :success
      should_assign_to :projects, :tags
      
      should "filter projects" do
        assert assigns['projects'].include? @project1
        assert assigns['projects'].include? @project2
        assert assigns['projects'].include? @project3
        assert !( assigns['projects'].include? @project4 )
      end
      
      should "default sort by priority (larger -> higher)" do
        assert assigns['projects'][0] == @project3
        assert assigns['projects'][1] == @project1
        assert assigns['projects'][2] == @project2
      end
    end
  end
end
