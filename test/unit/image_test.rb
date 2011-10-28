require File.dirname(__FILE__) + '/../test_helper'

class ImageTest < ActiveSupport::TestCase
  context "An image" do
    setup do
      @image = Factory :image
      @deleted_image = Factory :image
      @deleted_image.destroy
    end

    teardown do
      Image.delete_all
    end

    should "have some values" do
      assert_equal "Image Name", @image.name
      assert_equal "Image Description", @image.description
      #assert_equal false, @image.sync_flickr
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
    
    should "respond to active?" do
      assert @image.active?
      assert !@deleted_image.active?
    end
  end
end
