require File.dirname(__FILE__) + '/../test_helper'

class WebcamImageTest < ActiveSupport::TestCase
  context "A webcam image" do
    setup do
      @image = Factory :webcam_image
    end

    teardown do
      WebcamImage.delete_all
    end

    should "have some values" do
      assert_equal Date.today, @image.date.to_date
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
  end
end
