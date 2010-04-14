class Video < ActiveRecord::Base
  has_attached_file :thumbnail, 
                      :styles => { :thumb => '100x100>' }, 
                      :default_style => :thumb,
                      :url => "/assets/videos/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/videos/:id/:style/:basename.:extension"
                      
  belongs_to :project
end
