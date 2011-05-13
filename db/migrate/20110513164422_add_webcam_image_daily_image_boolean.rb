class AddWebcamImageDailyImageBoolean < ActiveRecord::Migration
  def self.up
    add_column :webcam_images, :daily_image, :boolean
  end

  def self.down
    remove_column :webcam_images, :daily_image
  end
end
