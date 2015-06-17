require File.dirname(__FILE__) + '/../test_helper'
#require 'flickr'

class ImageFlickrTest < ActiveSupport::TestCase
=begin
  attr_accessor :flickr, :flickr_cache
  
  # Hack - teardown doesn't seem to have access to instance variables set in setup
  FLICK = Flickr.new(FLICKR_CONFIG[:flickr_cache_file], FLICKR_CONFIG[:flickr_key], FLICKR_CONFIG[:flickr_shared_secret])
  CACHE = {:title => FLICK.photos.getInfo(4601892842).title, :description => FLICK.photos.getInfo(4601892842).description }
  
  context "An image with flickr_id and sync_flickr" do
    setup do
      @project = Factory :project
      @image = Factory :image, :project => @project, :sync_flickr => true, :flickr_id => 4601892842
      @flickr = @image.flickr
    end

    teardown do
      FLICK.photos.setMeta(4601892842, CACHE[:title], CACHE[:description])
      Project.all(:conditions => 'flickr_id IS NOT NULL').each {|p| FLICK.photosets.delete(p.flickr_id) }
      Project.delete_all
      Image.delete_all
    end
    
    should "push data to flickr" do
      flickr_info = @flickr.photos.getInfo(4601892842) 
      assert_equal "Image Name", flickr_info.title
      assert flickr_info.description.include? "Image Description"
    end
      
    should "create project's flickr set if it doesn't exist" do
      assert !(@image.project.flickr_id.blank?)
      assert @flickr.photosets.getList( FLICKR_CONFIG[:flickr_id] ).map(&:title).include? @project.name
    end
    
    should "add image to project's flickr set if not already member" do
      assert @flickr.photosets.getPhotos(@image.project.flickr_id ).map(&:id).include? @image.flickr_id.to_s
    end

    should "not pull description if it's the same as the project's" do
      project = Factory :project, :description => "The project begins with a 1980’s home-builder house fronting on lake austin. The original design did not harness views to the lake and Mount Bonnell, nor did it respect the ecological sensitivity of its site. The challenge was to develop a sensitive and inventive result out of a pre-existing condition. Through the use of glass, steel, detailing and light the home has been adaptively reinvented. Reflection, translucency, color and geometry conspire to bring natural light deep into the house. A new solarium, pool, and vegetative roof are tuned to interact with the natural context. Exterior materials and refined detailing of the roof structure give the volume clean lines and a bold presence, while abstracting the form of the original dormers and gable roof. Further connecting the home to its site, the roof begins to dissolve where a glass clad chimney and slatted wood screen stand in relief against the sky.\n\n\nBercy Chen Studio LP\n<a href=\"http://www.bcarc.com\" rel=\"nofollow\">www.bcarc.com</a>"
      image = Factory :image, :sync_flickr => true, :flickr_id => 4601892842, :project => project
      
      assert_equal "Image Description", image.description
    end
  end
      
  context "An image with :flickr_sync = false but flickr_id" do
    setup do
      @project = Factory :project
      @image = Factory :image, :project => @project, :flickr_id => 4601892842
      @flickr = @image.flickr
    end
    
    teardown do
      FLICK.photos.setMeta(4601892842, CACHE[:title], CACHE[:description])
      Project.all(:conditions => 'flickr_id IS NOT NULL').each {|p| FLICK.photosets.delete(p.flickr_id) }
      Project.delete_all
      Image.delete_all
    end
    
    should "not push data to flickr" do
      flickr_info = @flickr.photos.getInfo(4601892842) 
      assert_not_equal "Image Name", flickr_info.title
      assert !( flickr_info.description.include?("Image Description") )
    end
  end

  context "An image with flickr_id and sync_flickr but no description" do
    setup do
      @project = Factory :project
      @image = Factory :image, :project => @project, :flickr_id => 4601892842, :sync_flickr => true, :description => nil
      @flickr = @image.flickr
    end
    
    teardown do
      FLICK.photos.setMeta(4601892842, CACHE[:title], CACHE[:description])
      Project.all(:conditions => 'flickr_id IS NOT NULL').each {|p| FLICK.photosets.delete(p.flickr_id) }
      Project.delete_all
      Image.delete_all
    end
    
    should "update title but not description" do
      flickr_info = @flickr.photos.getInfo(4601892842) 
      assert_equal "Image Name", flickr_info.title
      assert !( flickr_info.description.nil? )        
    end
  end
=end
end
