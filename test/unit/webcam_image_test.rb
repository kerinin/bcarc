require File.dirname(__FILE__) + '/../test_helper'

class WebcamImageTest < ActiveSupport::TestCase
  context "A webcam image" do
    setup do
      @project = Factory :project, :webcam_ftp_dir => '/'
      @image = Factory :webcam_image, :project => @project
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
  end
end
