Factory.define :plan do |p|
  p.name "Plan Name"
  p.project {|p| p.association(:project)}
  p.attachment File.new("#{Rails.root}/public/images/logo_01.jpg")
end