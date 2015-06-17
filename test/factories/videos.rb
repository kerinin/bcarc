FactoryGirl.define :video do |v|
  v.name "Video Name"
  v.description "Video Description"
  v.width 800
  v.height 480
  v.uri 'http://vimeo.com/8063014'
  v.project {|v| v.association(:project)}
end
