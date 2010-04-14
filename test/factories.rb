#Factory.define :product do |p|
#  p.name "Factory-defined Product Name"
#  p.description "Description"
#  p.price 100
#  p.count_on_hand 1
#  p.available_on Time.gm( '1990' )
#  p.owner {|u| u.association(:seller) }
#end

Factory.define :image do |i|
  i.name "Image Name"
  i.description "Image Description"
  i.sync_flickr false
  i.project {|p| p.association(:project)}
end

Factory.define :page do |p|
  p.name "Page Name"
  p.content "Page Content"
end

Factory.define :plan do |p|
  p.name "Plan Name"
  p.project {|p| p.association(:project)}
end

Factory.define :project do |p|
  p.name "Project Name"
  p.short "Project Short Description"
  p.description "Project Description"
  p.date_completed 1.year.ago
  p.location "Project Location"
  p.priority 3
end

Factory.define :tag do |t|
  t.name "Tag Name"
end

Factory.define :video do |v|
  v.name "Video Name"
  v.description "Video Description"
  v.width 800
  v.height 480
  v.uri 'http://vimeo.com/8063014'
  v.project {|v| v.association(:project)}
end

