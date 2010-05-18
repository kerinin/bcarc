class Image < ActiveRecord::Base
  attr_accessor :flickr
  
  has_attached_file :attachment, 
    :styles => { 
      :thumb => '55x40#', 
      :thumb_ds => { :geometry => '55x40#', :processors => [:thumbnail, :modulate], :saturation => 0 }, #[:auto_orient, :thumbnail, :modulate], :saturation => 0 },
      :index => '390x180#', 
      :full => '800x800>'#,
      #:original => {:processors => [:auto_orient]}
    }, 
    #:processors => [:auto_orient, :thumbnail],
    :default_style => :index,
    :url => ":s3_alias_url",
    :path => "projects/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :s3_host_alias => "assets.bcarc.com",
    :bucket => 'assets.bcarc.com',
    :s3_headers => {'Cache-Control' => 'max-age=31557600'}
                      
  belongs_to :project
  
  validates_attachment_presence :attachment
  validates_presence_of :plan_x, :plan_y, :locator_angle, :unless => Proc.new {|i| i.plan_x.blank? && i.plan_y.blank? && i.locator_angle.blank? }
  validates_presence_of :flickr_id, :if => Proc.new {|i| i.sync_flickr}
  validates_presence_of :project_id
  
  #translates :name, :description
  
  acts_as_list :scope => :project
  
  def html_description
    #Wikitext::Parser.new().parse( description.to_s )
    return nil unless description
    
    RedCloth.new( description ).to_html
  end
  
  def destroy
    self.deleted_at = Time.now
    self.save!
  end
  
  def push_data_to_flickr
    return false if self.flickr_id.blank?
    
    flickr.photos.setMeta( self.flickr_id, self.name, self.description )
  end
  
  def pull_data_from_flickr
    return false if self.flickr_id.blank?
    
    flickr_photo = flickr.photos.getInfo( self.flickr_id )
    self.name = flickr_photo.title
    self.description = flickr_photo.description unless flickr_photo.description.include? self.project.description[0..20]
  end
  
  def flickr
    @flickr ||= Flickr.new(FLICKR_CONFIG[:flickr_cache_file], FLICKR_CONFIG[:flickr_key], FLICKR_CONFIG[:flickr_shared_secret])
  end
end
