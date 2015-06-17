FactoryGirl.define :webcam_image do |i|
  i.date DateTime.now
  i.project {|p| p.association(:project)}
  i.attachment File.new("#{Rails.root}/public/images/logo_01.jpg")
  i.source_url 'red_bluff_cam20110222102315087.jpg'
end
