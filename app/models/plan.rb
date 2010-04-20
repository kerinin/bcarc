class Plan < ActiveRecord::Base
  belongs_to :project
  
  has_many :images
  
  acts_as_list :scope => :project
  
  has_attached_file :attachment, 
    :styles => { :thumb => '55x40#', :full => '800x800>'}, 
    :default_style => :index,
    :url => "/assets/projects/:id/plans/:style/:basename.:extension",
    :path => "projects/:id/plans/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :bucket => 'bcstudio-rails'
    
  translates :name
end
