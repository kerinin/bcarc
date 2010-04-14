require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  context "A video" do
    setup do
      @youtube_video = Factory :video, :uri => 'http://www.youtube.com/v/-w9yeGIqcLg'
      @vimeo_video = Factory :video, :uri => 'http://vimeo.com/8063014'
    end

    teardown do
      Video.delete_all
    end

    should_eventually "have some values" do
    end
    
    should "return the video's service" do
      assert_equal @youtube_video.service, 'youtube'
      assert_equal @vimeo_video.service, 'vimeo'
    end
    
    should "return the video's ID" do
      assert_equal @youtube_video.youtube_id, '-w9yeGIqcLg'
      assert_equal @vimeo_video.vimeo_id, '8063014'
    end
    
    should_eventually "retrieve, modify, and attach the video's thumbnail" do
    end
  end
end
