require File.dirname(__FILE__) + '/../test_helper'

class WebcamImageTest < ActiveSupport::TestCase
  context "A webcam image" do
    setup do
      @project = Factory :project, :webcam_ftp_dir => '/'
      @image = Factory :webcam_image, :project => @project, :date => Date::today
    end

    teardown do
      WebcamImage.delete_all
    end

    should "have some values" do
      assert_not_nil @image.date
    end
    
    should_eventually "handle attached files" do
    end
    
    should_eventually "format thumbnails" do
    end
    
    should "raise error if image missing" do
      assert_raise ActiveRecord::RecordInvalid do
        v = WebcamImage.new
        v.save!     
      end
    end
    
    should "set 'daily_image' to false for other images in the same day" do
      @image2 = Factory :webcam_image, :project => @project, :date => Date::today
      @image3 = Factory :webcam_image, :project => @project, :date => Date::today + 1, :daily_image => true
      
      @image.update_attributes(:daily_image => true)
      
      assert @image.daily_image
      assert @image3.daily_image
      
      @image2.update_attributes(:daily_image => true)
      
      assert !@image.reload.daily_image
      assert @image2.reload.daily_image
      assert @image3.reload.daily_image
    end
  end
end
