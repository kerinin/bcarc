Factory.define :webcam_image do |i|
  i.date DateTime.now
  i.project {|p| p.association(:project)}
  i.attachment "#{Rails.root}/public/images/logo_01.jpg"
end