require File.dirname(__FILE__) + '/../test_helper'

class ImageTest < ActiveSupport::TestCase
  context "An image" do
    setup do
      @image = Factory :image
    end

    teardown do
      Image.delete_all
    end

    should_eventually "have some values" do
      assert_equal "Image Name", @image.name
      assert_equal "Image Description", @image.description
      assert_equal false, @image.sync_flickr
    end
    
    should_eventually "handle attached files" do
    end
    
    should_eventually "format thumbnails" do
    end
    
    should "raise error if image missing" do
      assert_raise ActiveRecord::RecordInvalid do
        v = Image.new
        v.save!     
      end
    end
    
    should "set deleted_at when Image#destroy called" do
      @image.destroy
      
      assert @image.deleted_at.present?
      assert Image.exists? @image
    end
    
    context "with flickr id" do
      setup do
        @image.flickr_id = 4601892842
          
        @flickr = Flickr.new(FLICKR_CONFIG[:flickr_cache_file], FLICKR_CONFIG[:flickr_key], FLICKR_CONFIG[:flickr_shared_secret])
        @flickr_cache = {:title => @flickr.photos.getInfo(4601892842).title, :description => @flickr.photos.getInfo(4601892842).description }
      end
      
      teardown do
        @flickr.photos.setMeta(4601892842, @flickr_cache[:title], @flickr_cache[:description])
      end
      
      should "push data to flickr" do
        @image.push_data_to_flickr  
        @flickr_info = @flickr.photos.getInfo(4601892842) 
        assert_equal "Image Name", @flickr_info.title
        assert_equal "Image Description", @flickr_info.description
      end
    
      should "pull data from flickr" do
        @image.pull_data_from_flickr
        
        assert_equal "Austin Modern Peninsula Lake House", @image.name
        assert @image.description.include? "The project begins with a"
      end
      
      should "not pull description if it's the same as the project's" do
        @image.project.description = "The project begins with a 1980’s home-builder house fronting on lake austin. The original design did not harness views to the lake and Mount Bonnell, nor did it respect the ecological sensitivity of its site. The challenge was to develop a sensitive and inventive result out of a pre-existing condition. Through the use of glass, steel, detailing and light the home has been adaptively reinvented. Reflection, translucency, color and geometry conspire to bring natural light deep into the house. A new solarium, pool, and vegetative roof are tuned to interact with the natural context. Exterior materials and refined detailing of the roof structure give the volume clean lines and a bold presence, while abstracting the form of the original dormers and gable roof. Further connecting the home to its site, the roof begins to dissolve where a glass clad chimney and slatted wood screen stand in relief against the sky."
        @image.pull_data_from_flickr
        
        assert_equal "Image Description", @image.description
      end
    end
  end
end
