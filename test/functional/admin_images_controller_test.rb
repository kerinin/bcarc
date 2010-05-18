require File.dirname(__FILE__) + '/../test_helper'

class Admin::ImagesControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = Factory :project
      
      @image1 = Factory :image, :project => @project, :flickr_id => 4601892842
      @image2 = Factory :image, :project => @project
      
      @video1 = Factory :video, :project => @project
      @video2 = Factory :video, :project => @project
      
      @project.thumbnail = @image1
      @project.save!
      
      @flickr = Flickr.new(FLICKR_CONFIG[:flickr_cache_file], FLICKR_CONFIG[:flickr_key], FLICKR_CONFIG[:flickr_shared_secret])
      @flickr_cache = {:title => @flickr.photos.getInfo(4601892842).title, :description => @flickr.photos.getInfo(4601892842).description }
    end
    
    teardown do
      Project.delete_all
      Image.delete_all
      Video.delete_all
      @flickr.photos.setMeta(4601892842, @flickr_cache[:title], @flickr_cache[:description])
    end
        
    should_route :get, 'admin/projects/project_id/images/image_id/pull_flickr', :controller => 'admin/images', :action => :pull_flickr, :project_id => 'project_id', :id => 'image_id'
    context "on GET to :pull_flickr" do
      setup do
        get :pull_flickr, :project_id => @project.to_param, :id => @image1.to_param
      end
      
      should "pull data from flickr" do
        assert_equal "Austin Modern Peninsula Lake House", assigns['image'].name
        assert assigns['image'].description.include? "The project begins with a"
      end
    end
      
    context "on GET to :pull_flickr" do
      setup do
        @image1.project.description = "The project begins with a 1980’s home-builder house fronting on lake austin. The original design did not harness views to the lake and Mount Bonnell, nor did it respect the ecological sensitivity of its site. The challenge was to develop a sensitive and inventive result out of a pre-existing condition. Through the use of glass, steel, detailing and light the home has been adaptively reinvented. Reflection, translucency, color and geometry conspire to bring natural light deep into the house. A new solarium, pool, and vegetative roof are tuned to interact with the natural context. Exterior materials and refined detailing of the roof structure give the volume clean lines and a bold presence, while abstracting the form of the original dormers and gable roof. Further connecting the home to its site, the roof begins to dissolve where a glass clad chimney and slatted wood screen stand in relief against the sky."
        @image1.project.save!
        
        get :pull_flickr, :project_id => @project.to_param, :id => @image1.to_param
      end

      should "not pull description if it's the same as the project's" do
        assert_equal "Image Description", assigns['image'].description
      end      
    end
    
    context "on POST to :update with :flickr_sync = true" do
      setup do
        @image1.sync_flickr = true
        @image1.save!
        
        post :update, :project_id => @project.to_param, :id => @image1.to_param
      end
      
      should "push data to flickr" do
        @flickr_info = @flickr.photos.getInfo(4601892842) 
        assert_equal "Image Name", @flickr_info.title
        assert @flickr_info.description.include? "Image Description"
      end
    end
  
    context "on POST to :update with :flickr_sync = false" do
      setup do
        @image1.sync_flickr = false
        @image1.save!
        
        post :update, :project_id => @project.to_param, :id => @image1.to_param
      end
      
      should "not push data to flickr" do
        @flickr_info = @flickr.photos.getInfo(4601892842) 
        assert_not_equal "Image Name", @flickr_info.title
        assert !( @flickr_info.description.include?("Image Description") )
      end
    end
  end
end
