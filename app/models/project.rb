class Project < ActiveRecord::Base  
  has_many :images, 
    :order => 'position', 
    :dependent => :destroy,
    :after_add => [ :set_default_thumbnail, Proc.new {|p,i| p.thumbnail.blank?} ]
  has_many :videos, :order => 'position', :dependent => :destroy
  has_many :plans, :order => 'position', :dependent => :destroy
  
  belongs_to :thumbnail, :class_name => 'Image'
  
  has_and_belongs_to_many :tags, :after_add => :set_has_tags, :after_remove => :set_has_tags
  
  before_validation :geocode_address, :if => Proc.new {|p| p.show_map && ( p.city_changed? || p.address_changed? ) }, :unless => Proc.new {|p| p.city.empty? }
  
  validates_presence_of :name
  validates_presence_of :city, :if => Proc.new {|p| p.show_map}, :message => "City (at minimum) required to show map"
  
  make_permalink :with => :name
  
  translates :short, :description
  
  named_scope :active, :conditions => { :has_tags => true }
  named_scope :by_priority, :order => 'priority'
  named_scope :by_date, :order => 'completed_at'
  named_scope :by_name, :order => 'name'
  named_scope :to_map, :conditions => { :show_map => true }
  
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
    self.has_tags = self.tags.count > 0
    self.save!
  end
    
  private
  
  def set_default_thumbnail(image)
    self.thumbnail ||= image
  end
  
  def save_permalink
    return unless I18n.locale == :en
    super
  end
end
