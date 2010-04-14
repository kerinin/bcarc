require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  context "An image" do
    setup do
      @image = Factory :image
    end

    teardown do
      Image.delete_all
    end

    should_eventually "have some values" do
    end
    
    should_eventually "handle attached files" do
    end
    
    should_eventually "format thumbnails" do
    end
  end
end
