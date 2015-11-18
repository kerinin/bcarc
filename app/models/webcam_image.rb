require 'yaml'

class WebcamImage < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper

  paperclip_params = YAML::load(File.open("#{Rails.root}/config/paperclip.yml"))[Rails.env.to_s]
  params = { :styles => { 
      :thumb => '55x40#', 
      :thumb_ds => { :geometry => '55x40#', :processors => [:thumbnail, :modulate], :saturation => 0 }, #[:auto_orient, :thumbnail, :modulate], :saturation => 0 },
      :full => '800x800>'
    }, 
    :default_style => :full,
    :path => "projects/:project_id/webcam_images/:style/:source_url"
    }
    
  has_attached_file :attachment, ( paperclip_params ? params.merge(paperclip_params) : params )
                      
  belongs_to :project
  
  before_validation :date_from_url, :on => :create, :unless => Proc.new {Rails.env == 'test' || !self.attachment.nil?}
  before_save :update_daily_image, :if => Proc.new {|i| i.daily_image_changed? && i.daily_image}
  
  validates_attachment_presence :attachment, :unless => Proc.new {Rails.env == 'test'}
  validates_presence_of :project, :source_url
  
  #red_bluff_cam20110512_104500M.jpg 12-May-2011 10:45	 34K
  #red_bluff_cam20110222103815060.jpg 22-Feb-2011 10:38	 45K
  def date_from_url
    #r = /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d+)/
    # [year,month,date,hour,minute,second,ms]
    r = /(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})/
    # [year,month,date,hour,minute,second,ms]
    values = self.source_url.scan(r)
    self.date = DateTime.strptime(values.join(' '), "%Y %m %d %H %M %S")
  end

  def download_remote_image
    puts "downloading image"
    
    require 'net/ftp'
    ftp = Net::FTP.new('ftp.bcarc.com')
    ftp.passive = true
    ftp.login(user = "ftpuser", passwd = "rSW0WstxFTJvNNHP")
    ftp.chdir(self.project.webcam_ftp_dir)
    
    tempfile = Tempfile.new(self.source_url)
    ftp.getbinaryfile(self.source_url, tempfile.path)
    
    self.attachment = tempfile
    self.attachment_file_name = self.source_url
  end
    
  private
  
  def update_daily_image
    day_start = DateTime.new(self.date.year, self.date.month, self.date.day, 0)
    day_end = DateTime.new(self.date.year, self.date.month, self.date.day, 24)
    self.project.webcam_images.where('date >= ? AND date < ?', day_start, day_end ).where(:daily_image => true).each do |image|
      image.update_attributes(:daily_image => false)
    end
  end
end
