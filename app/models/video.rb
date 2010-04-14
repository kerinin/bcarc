class Video < ActiveRecord::Base
  has_attached_file :thumbnail, 
                      :styles => { :thumb => '100x100>' }, 
                      :default_style => :thumb,
                      :url => "/assets/videos/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/videos/:id/:style/:basename.:extension"
                      
  belongs_to :project
  
  def service
    return 'youtube' if self.uri.include?( 'youtube.com' )
    return 'vimeo' if self.uri.include?( 'vimeo.com' )
  end
  
  def youtube_id
    self.uri.split('/')[-1]
  end
  
  def vimeo_id
    self.uri.split('/')[-1]
  end           
end