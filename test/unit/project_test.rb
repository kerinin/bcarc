require File.dirname(__FILE__) + '/../test_helper'



# NOTE: test associated get deleted


class ProjectTest < ActiveSupport::TestCase
  context "A project" do
    setup do
      @completed = 1.year.ago
      
      @project = Factory :project, 
        :name => 'Test Project',
        :description => 'Project Description',
        :short => 'Short Description',
        :date_completed => @completed,
        :location => '100 5th Street',
        :priority => 5,
        :thumbnail => Factory(:image)
        
      @plan1 = Factory :plan, :project => @project
      @plan2 = Factory :plan, :project => @project
      
      @image1 = Factory :image, :project => @project
      @image2 = Factory :image, :project => @project
      
      @video1 = Factory :video, :project => @project
      @video2 = Factory :video, :project => @project
      
      @tag = Factory :tag
      
      @project.tags << @tag
    end
    
    teardown do
      Plan.delete_all
      Image.delete_all
      Video.delete_all
      Tag.delete_all
      Project.delete_all
    end
    
    should "have some values" do
      assert_equal @project.name, 'Test Project'
      assert_equal @project.description, 'Project Description'
      assert_equal @project.short, 'Short Description'
      assert_equal @project.date_completed, @completed
      assert_equal @project.location, '100 5th Street'
      assert_equal @project.priority, 5
    end
    
    should "have associated plans" do
      assert @project.plans.include? @plan1
      assert @project.plans.include? @plan2
      assert_equal @plan1.project, @project
      assert_equal @plan2.project, @project
    end
    
    should "have associated images" do
      assert @project.images.include? @image1
      assert @project.images.include? @image2
      assert_equal @image1.project, @project
      assert_equal @image2.project, @project
    end
    
    should "have associated videos" do
      assert @project.videos.include? @video1
      assert @project.videos.include? @video2
      assert_equal @video1.project, @project
      assert_equal @video2.project, @project
    end
    
    should "have associated tags" do
      assert @project.tags.include? @tag
      assert @tag.projects.include? @project
    end
  end
end
