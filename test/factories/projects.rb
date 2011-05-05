Factory.define :project do |p|
  p.name "Project Name"
  p.short "Project Short Description"
  p.description "Project Description"
  p.date_completed 1.year.ago
  p.priority 3
  p.show_map false
end