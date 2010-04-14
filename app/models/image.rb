class Image < ActiveRecord::Base
  has_attached_file :attachment, 
                      :styles => { :thumb => '100x100>', :index => '380x200#', :full => '800x800>' }, 
                      :default_style => :index,
                      :url => "/assets/projects/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/projects/:id/:style/:basename.:extension"
                      
  belongs_to :project
end
