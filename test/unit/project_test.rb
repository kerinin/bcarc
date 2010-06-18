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
        :address => '100 5th Street',
        :city => 'San Francisco',
        :state => 'CA',
        :priority => 5,
        :thumbnail => Factory(:image)
        
      @inactive_project = Factory :project
        
      @plan1 = Factory :plan, :project => @project
      @plan2 = Factory :plan, :project => @project
      
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
  
    should "set has_tags on" do
      assert_equal true, @project.has_tags
      assert_equal true, @project.has_tags?
    end
    
    should "be active if it has a tag" do
      assert_contains Project.active, @project
    end
    
    should "not be active it it doesn't have a tag" do
      assert_does_not_contain Project.active, @inactive_project
    end
    
    should "successfully chain scopes" do
      assert_contains Project.active.random( 6, :conditions => { :priority => 1..3 }), @project
    end
    
    should "have some values" do
      assert_equal @project.name, 'Test Project'
      assert_equal @project.description, 'Project Description'
      assert_equal @project.short, 'Short Description'
      assert_equal @project.date_completed, @completed
      assert_equal @project.address, '100 5th Street'
      assert_equal @project.city, 'San Francisco'
      assert_equal @project.state, 'CA'
      assert_equal @project.priority, 5
    end
    
    should "have associated plans" do
      assert @project.plans.include? @plan1
      assert @project.plans.include? @plan2
      assert_equal @plan1.project, @project
      assert_equal @plan2.project, @project
    end
    
    should "have associated images" do
      @image1 = Factory :image, :project => @project
      @image2 = Factory :image, :project => @project
      
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
    
    should "not geocode if map=false" do
      @project.address = '1111 East 11th Street'
      @project.city = 'Austin'
      @project.state = 'TX'
      @project.save!
      
      assert @project.latitude.blank?
      assert @project.longitude.blank?
    end
          
    should_eventually "pull geocoded lat/lon on address save if map=true" do
      @project.show_map = true
      @project.address = '1111 East 11th Street'
      @project.city = 'Austin'
      @project.state = 'TX'
      @project.save!
      
      assert @project.latitude == 30.268807
      assert @project.longitude == -97.728902
      assert @project.map_accuracy == 8
    end
 
    should "save the first attached image as the thumbnail if none specified" do
      @project2 = Factory :project
      @image = Factory :image
      @project2.images << @image
      
      assert_equal @image, @project2.thumbnail
    end
    
    should "i18n description" do
      I18n.locale = :en
      @project.description = 'English'
      I18n.locale = :fr
      @project.description = 'French'
      
      assert @project.description = 'French'
      I18n.locale = :en
      assert @project.description = 'English'
    end
    
    should "i18n short" do
      I18n.locale = :en
      @project.short = 'English'
      I18n.locale = :fr
      @project.short = 'French'
      
      assert @project.short = 'French'
      I18n.locale = :en
      assert @project.short = 'English'
    end
  end
end
