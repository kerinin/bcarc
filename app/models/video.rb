class Video < ActiveRecord::Base
  has_attached_file :thumbnail, 
    :styles => { :thumb => '100x100>' }, 
    :default_style => :thumb,
    :url => "/assets/videos/:id/:style/:basename.:extension",
    :path => "videos/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :bucket => 'bcstudio-paperclip'

                      
  belongs_to :project
  
  acts_as_wikitext :description
  
  acts_as_list :scope => :project
  
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
