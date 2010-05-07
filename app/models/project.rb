class Project < ActiveRecord::Base  
  has_many :images, :order => 'position', :dependent => :destroy
  has_many :videos, :order => 'position', :dependent => :destroy
  has_many :plans, :order => 'position', :dependent => :destroy
  
  belongs_to :thumbnail, :class_name => 'Image'
  
  has_and_belongs_to_many :tags
  
  #has_permalink :name
  make_permalink :with => :name
  
  #translates :name, :short, :description
  
  def kml?
    !( latitude.nil? || longitude.nil? )
  end
  
  def html_description
    #Wikitext::Parser.new().parse( description.to_s )
    return nil if description.empty?
    
    RedCloth.new( description ).to_html
  end
  
  def html_short
    #Wikitext::Parser.new().parse( short.to_s )
    return nil if short.empty?
    
    RedCloth.new( short ).to_html
  end
  
  def year
    self.date_completed.strftime('%Y')
  end
end
