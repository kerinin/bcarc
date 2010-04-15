class Image < ActiveRecord::Base
  has_attached_file :attachment, 
    :styles => { :thumb => '100x100>', :index => '380x200#', :full => '800x800>' }, 
    :default_style => :index,
    :url => "/assets/projects/:id/:style/:basename.:extension",
    :path => "projects/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :bucket => 'bcstudio-rails'
                      
  belongs_to :project
  
  acts_as_wikitext :description
end
