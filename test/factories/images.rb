Factory.define :image do |i|
  i.name "Image Name"
  i.description "Image Description"
  i.sync_flickr false
  i.project {|p| p.association(:project)}
  i.attachment "#{Rails.root}/public/images/logo_01.jpg"
end