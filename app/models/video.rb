require 'rexml/document'
require 'open-uri'

class Video < ActiveRecord::Base
  
  paperclip_params = YAML::load(File.open("#{RAILS_ROOT}/config/paperclip.yml"))[RAILS_ENV.to_sym]
  params = { :styles => { 
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
    :path => "videos/:id/:style/:basename.:extension"
    }
                 
  has_attached_file :thumbnail, ( paperclip_params ? params.merge(paperclip_params) : params )
    
  belongs_to :project
  
  before_validation_on_create :fetch_thumbnail
  
  validates_attachment_presence :thumbnail, :unless => Proc.new {RAILS_ENV == 'test'}
  validates_presence_of :uri, :project_id
  
  acts_as_list :scope => :project
  
  translates :name, :description
  
  named_scope :by_position, :order => 'position'

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
      return
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
