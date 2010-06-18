require File.dirname(__FILE__) + '/../test_helper'

class TagsControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @tag1 = Factory :tag
      @tag2 = Factory :tag
      
      @project1 = Factory :project, :date_completed => 3.month.ago, :priority => 2
      @project1.tags << [@tag1, @tag2]
      @project2 = Factory :project, :date_completed => 1.months.ago, :priority => 1
      @project2.tags << @tag1
      @project3 = Factory :project, :date_completed => 2.months.ago, :priority => 3
      @project3.tags << @tag1
      @project4 = Factory :project, :priority => 0
      @project4.tags << @tag2
      @inactive_project = Factory :project

      @image1 = Factory :image, :project => @project1
      @image2 = Factory :image, :project => @project2
      @image3 = Factory :image, :project => @project3
    end
    
    teardown do
      Project.delete_all
      Tag.delete_all
    end
    
    should_route :get, 'Work/tag_id', :controller => :tags, :action => :show, :id => 'tag_id', :locale => :en
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
      
      should_eventually "default sort by priority (1 = most important)" do
        assert assigns['projects'][0] == @project3
        assert assigns['projects'][1] == @project1
        assert assigns['projects'][2] == @project2
      end
    end
    
    context "on GET to :show all" do
      setup do
        get :show, :all => true
      end
      should_respond_with :success
      should_assign_to :projects, :tags
            
      should "include all active projects" do
        assert_contains assigns['projects'], @project1
        assert_contains assigns['projects'], @project2
        assert_contains assigns['projects'], @project3
        assert_contains assigns['projects'], @project4
      end
      
      should "exclude inactive projects" do
        assert_does_not_contain assigns['projects'], @inactive_project
      end
    end
  end
end
