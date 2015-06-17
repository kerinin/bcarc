require File.dirname(__FILE__) + '/../test_helper'

class TagsControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @tag1 = FactoryGirl.create :tag
      @tag2 = FactoryGirl.create :tag
      
      @project1 = FactoryGirl.create :project, :date_completed => 3.month.ago, :priority => 2
      @project1.tags << [@tag1, @tag2]
      @project2 = FactoryGirl.create :project, :date_completed => 1.months.ago, :priority => 1
      @project2.tags << @tag1
      @project3 = FactoryGirl.create :project, :date_completed => 2.months.ago, :priority => 3
      @project3.tags << @tag1
      @project4 = FactoryGirl.create :project, :priority => 0
      @project4.tags << @tag2
      @inactive_project = FactoryGirl.create :project

      @image1 = FactoryGirl.create :image, :project => @project1
      @image2 = FactoryGirl.create :image, :project => @project2
      @image3 = FactoryGirl.create :image, :project => @project3
    end
    
    teardown do
      Project.delete_all
      Tag.delete_all
    end
    
    should route( :get, 'Work/tag_id').to( :controller => :tags, :action => :show, :id => 'tag_id')
    should route( :get, 'Work').to( :controller => :tags, :action => :show, :all => true)
    #should route( :get, 'Work/All').to( :controller => :tags, :action => :show, :all => true)
    
    context "on GET to :show" do
      setup do
        get :show, :id => @tag1.to_param
      end
      should respond_with( :success)
      should assign_to( :projects)
      should assign_to( :tags)
      
      should "filter projects" do
        assert assigns['projects'].include? @project1
        assert assigns['projects'].include? @project2
        assert assigns['projects'].include? @project3
        assert !( assigns['projects'].include? @project4 )
      end
      
      should "default sort by priority (1 = most important)" do
        assert assigns['projects'][0] == @project2
        assert assigns['projects'][1] == @project1
        assert assigns['projects'][2] == @project3
      end
    end

    context "on GET to :show with legacy URLs" do
     setup do
       previous_param = @tag1.to_param
 
       @tag1.name = 'New Name 1'
       @tag1.save!
       second_param = @tag1.to_param
 
       @tag1.name = 'New Name 2'
       @tag1.save!
 
       get :show, :id => previous_param
     end
     should respond_with( :success)

     should "find the tag from original" do
       assert assigns['tag'] == @tag1
     end
    end

    context "on GET to :show with another legacy URL" do
     setup do
       previous_param = @tag1.to_param
 
       @tag1.name = 'New Name 1'
       @tag1.save!
       second_param = @tag1.to_param
 
       @tag1.name = 'New Name 2'
       @tag1.save!
 
       get :show, :id => second_param
     end
     should respond_with( :success)

     should "find the tag from second" do
       assert assigns['tag'] == @tag1
     end
    end

    context "on GET to :show all" do
      setup do
        get :show, :all => true
      end
      should respond_with( :success)
      should assign_to( :projects)
      should assign_to( :tags)
            
      should "include all active projects" do
        assert_contains assigns['projects'].all, @project1
        assert_contains assigns['projects'].all, @project2
        assert_contains assigns['projects'].all, @project3
        assert_contains assigns['projects'].all, @project4
      end
      
      should "exclude inactive projects" do
        assert_does_not_contain assigns['projects'], @inactive_project
      end
    end
    
    context "on GET to :show by time" do
      setup do
        get :show, :id => @tag1.to_param, :by => 'chronology'
      end
      
      should respond_with(:success)
      should assign_to(:projects)
      should render_template('_by_chronology')
    end
    
    context "on GET to :show by location" do
      setup do
        @project1.update_attributes(:show_map => true, :city => 'Austin')
        get :show, :id => @tag1.to_param, :by => 'location'
      end
      
      should respond_with(:success)
      should assign_to(:projects)
      should render_template('_by_location')
    end
  end
end
