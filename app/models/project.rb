class Project < ActiveRecord::Base  
  has_many :images, 
    :dependent => :destroy,
    :after_add => [ :set_default_thumbnail, Proc.new {|p,i| p.thumbnail.blank?} ]
  has_many :videos, :dependent => :destroy
  has_many :plans, :dependent => :destroy
  has_many :webcam_images, :dependent => :destroy
  
  belongs_to :thumbnail, :class_name => 'Image'
  
  has_and_belongs_to_many :tags, :after_add => :set_has_tags, :after_remove => :set_has_tags
  
  before_validation :geocode_address, :if => Proc.new {|p| p.show_map && ( p.city_changed? || p.address_changed? ) }, :unless => Proc.new {|p| p.city.nil? }
  before_save :handle_legacy_permalink
  
  validates_presence_of :name
  validates_presence_of :city, :if => Proc.new {|p| p.show_map}, :message => "City (at minimum) required to show map"
  
  #make_permalink :with => :name
  
  # extend FriendlyId
  # friendly_id :name, :use => :slugged
  
  translates :short, :description
  
  def self.active
    where(:has_tags => true)
  end
  #named_scope :active, :conditions => { :has_tags => true }

  def self.by_priority
    order(:priority)
  end
  #named_scope :by_priority, :order => 'priority'

  def self.by_date
    order(:completed_at)
  end
  #named_scope :by_date, :order => 'completed_at'

  def self.by_name
    order(:name)
  end
  #named_scope :by_name, :order => 'name'

  def self.to_map
    where(:show_map => true)
  end
  #named_scope :to_map, :conditions => { :show_map => true }
  
  def kml?
    !( latitude.nil? || longitude.nil? )
  end
  
  def html_description
    #Wikitext::Parser.new().parse( description.to_s )
    return nil unless description
    
    RedCloth.new( description ).to_html
  end
  
  def html_short
    #Wikitext::Parser.new().parse( short.to_s )
    return nil unless short
    
    RedCloth.new( short ).to_html
  end
  
  def year
    self.date_completed.strftime('%Y')
  end
  
  def geocode_address
    results = Geocoding::get [address, city, state].join(' ')
    
    if results.status == Geocoding::GEO_SUCCESS
      self.latitude, self.longitude = results[0].latlon
      self.map_accuracy = results[0].accuracy
    end
  end

  def set_has_tags(*args)
    unless self.destroyed?
      self.has_tags = self.tags.count > 0
      self.save!
    end
  end
    
  private
  
  def set_default_thumbnail(image)
    self.thumbnail ||= image
  end
  
  def save_permalink
    return unless I18n.locale == :en
    super
  end
  
  def handle_legacy_permalink 
    if self.name_changed?
      self.legacy_permalinks = [self.legacy_permalinks, self.to_param].join(' ').strip
    end
  end
end
