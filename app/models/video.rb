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
    :url => ":s3_alias_url",
    :path => "videos/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :s3_host_alias => "assets.bcarc.com",
    :bucket => 'bcstudio'
                 
  belongs_to :project
  
  #before_validation_on_create :fetch_thumbnail
  before_validation :fetch_thumbnail
  
  validates_attachment_presence :thumbnail
  validates_presence_of :uri
  
  acts_as_list :scope => :project
  
  #translates :name, :description
  
  def html_description
    #Wikitext::Parser.new().parse( description.to_s )
    return nil unless description
    
    RedCloth.new( description ).to_html
  end
  
  def service
    return false if self.uri.blank?
    return 'youtube' if self.uri.include?( 'youtube.com' )
    return 'vimeo' if self.uri.include?( 'vimeo.com' )
  end
  
  def youtube_id
    self.uri.split('/')[-1]
  end
  
  def vimeo_id
    self.uri.split('/')[-1]
  end
  
  def player_loc
    case self.service
    when 'youtube'
      "http://www.youtube.com/swf/l.swf?swf=http%3A//s.ytimg.com/yt/swf/cps-vfl87635.swf&video_id=#{self.youtube_id}"
    when 'vimeo'
      "http://vimeo.com/moogaloop.swf?clip_id=#{ @object.vimeo_id }&amp;server=vimeo.com&amp;show_title=0&amp;show_byline=0&amp;show_portrait=0&amp;color=00adef&amp;fullscreen=1&amp;autoplay=1"
    end
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
    else 
      return false
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
