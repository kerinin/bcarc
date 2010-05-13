class Project < ActiveRecord::Base  
  has_many :images, :order => 'position', :dependent => :destroy
  has_many :videos, :order => 'position', :dependent => :destroy
  has_many :plans, :order => 'position', :dependent => :destroy
  
  belongs_to :thumbnail, :class_name => 'Image'
  
  has_and_belongs_to_many :tags
  
  before_validation :geocode_address, :if => Proc.new {|p| p.show_map && ( p.city_changed? || p.address_changed? ) }, :unless => Proc.new {|p| p.city.empty? }
  
  #has_permalink :name
  make_permalink :with => :name
  
  #translates :name, :short, :description
  
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
end
