require 'yaml'

class Image < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  
  attr_accessor :flickr
  
  paperclip_params = YAML::load(File.open("#{Rails.root}/config/paperclip.yml"))[Rails.env.to_s]
  params = { :styles => { 
      :thumb => '55x40#', 
      :thumb_ds => { :geometry => '55x40#', :processors => [:thumbnail, :modulate], :saturation => 0 }, #[:auto_orient, :thumbnail, :modulate], :saturation => 0 },
      :index => '390x180#', 
      :full => '800x800>',
      :project_description => '400x800>'#,
      #:original => {:processors => [:auto_orient]}
    }, 
    #:processors => [:auto_orient, :thumbnail],
    :default_style => :index,
    :path => "projects/:id/:style/:basename.:extension"
    }
    
  has_attached_file :attachment, ( paperclip_params ? params.merge(paperclip_params) : params )
                      
  belongs_to :project
  
  validates_attachment_presence :attachment, :unless => Proc.new {Rails.env == 'test'}
  validates_presence_of :plan_x, :plan_y, :locator_angle, :unless => Proc.new {|i| i.plan_x.blank? && i.plan_y.blank? && i.locator_angle.blank? }
  validates_presence_of :flickr_id, :if => Proc.new {|i| i.sync_flickr}
  validates_presence_of :project_id
  
  #translates :name, :description
  
  acts_as_list :scope => :project
  
  scope :active, lambda { where( {:deleted_at => nil} ) }
  #named_scope :active, :conditions => { :deleted_at => nil }
  
  after_save :push_data_to_flickr, :if => Proc.new {|i| i.sync_flickr }, :unless => Proc.new {|i| i.flickr_id.blank?}
  
  def active?
    self.deleted_at.blank?
  end
  
  def html_description
    #Wikitext::Parser.new().parse( description.to_s )
    return nil unless description
    
    RedCloth.new( description ).to_html
  end
  
  def destroy
    self.deleted_at = Time.now
    self.save!
  end
  
  def pull_data_from_flickr
    return false if self.flickr_id.blank?
    
    flickr_photo = flickr.photos.getInfo( self.flickr_id )
    self.name = flickr_photo.title
    
    unless flickr_photo.description.nil?
      self.description = flickr_photo.description unless ( self.project.description.present? && flickr_photo.description.include?( self.project.description[10..30] ))
    end
  end

  def flickr
    @flickr ||= Flickr.new(FLICKR_CONFIG[:flickr_cache_file], FLICKR_CONFIG[:flickr_key], FLICKR_CONFIG[:flickr_shared_secret])
  end
    
  private 

  def f_escape(text)
    h(text).gsub(/\r/, '')
  end
  
  def flickr_description
    self.description.blank? ? nil : ActionView::Base.new(Rails::Configuration.new.view_path).render(
    :partial => "admin/images/flickr_description",
    :locals => {:image => self}
    )
  end
    
  def push_data_to_flickr
    return false if self.flickr_id.blank?
    
    name = self.name || flickr.photos.getInfo(self.flickr_id).title
    description = flickr_description || flickr.photos.getInfo(self.flickr_id).description
    
    flickr.photos.setMeta( self.flickr_id, f_escape(name), f_escape(description) )
    
    if self.project.flickr_id
      add_to_project_set
    else
      create_project_set
    end
  end
  
  def create_project_set
    return false if self.flickr_id.blank?
    
    set = flickr.photosets.create( f_escape( self.project.name ), self.flickr_id, f_escape( self.project.description ) )
    self.project.flickr_id = set.id
    self.project.save!
  end   
  
  def add_to_project_set
    return false if self.flickr_id.blank? || self.project.flickr_id.blank?
    
    flickr.photosets.addPhoto( self.project.flickr_id, self.flickr_id ) unless flickr.photosets.getPhotos(self.project.flickr_id).map(&:id).include?( self.flickr_id )
  end
end
