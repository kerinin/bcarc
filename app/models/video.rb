require 'rexml/document'
require 'open-uri'

class Video < ActiveRecord::Base
  has_attached_file :thumbnail, 
    :styles => { 
      :thumb => {
        :geometry => '55x40#', 
        :processors => [:thumbnail, :overlay], 
        :overlay_size => '55x40', 
        :overlay => File.join(RAILS_ROOT,'public','images','video_overlay.png')
      },
      :thumb_ds => { 
        :geometry => '55x40#', 
        :processors => [:thumbnail, :modulate, :overlay], 
        :saturation => 0,
        :overlay_size => '55x40', 
        :overlay => File.join(RAILS_ROOT,'public','images','video_overlay.png')
      }
    }, 
    :default_style => :thumb,
    :url => "/assets/videos/:id/:style/:basename.:extension",
    :path => "videos/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :bucket => 'bcstudio-rails'

                      
  belongs_to :project
  
  #before_validation_on_create :fetch_thumbnail
  before_validation :fetch_thumbnail
  
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
  
  private
  
  def fetch_thumbnail
    image_url = case service
    when 'youtube'
      image_url = "http://img.youtube.com/vi/#{self.youtube_id}/default.jpg"
    when 'vimeo'
      xml = open(URI.parse("http://vimeo.com/api/v2/video/#{self.vimeo_id}.xml") )
      doc = REXML::Document.new(xml.read)
      image_url = doc.elements['//thumbnail_medium'].text
    end
    
    # Overlay...
    
    self.thumbnail = download_remote_image image_url
  end
  
  def download_remote_image image_url
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end    
end
