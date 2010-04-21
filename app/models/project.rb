class Project < ActiveRecord::Base  
  has_many :images, :order => 'position', :dependent => :destroy
  has_many :videos, :order => 'position', :dependent => :destroy
  has_many :plans, :order => 'position', :dependent => :destroy
  
  belongs_to :thumbnail, :class_name => 'Image'
  
  has_and_belongs_to_many :tags
  
  #has_permalink :name
  make_permalink :with => :name
  
  acts_as_wikitext :description
  
  translates :name, :short, :description
  
  def html_description
    Wikitext::Parser.new().parse( description.to_s )
  end
  
  def html_short
    Wikitext::Parser.new().parse( short.to_s )
  end
  
  def year
    self.date_completed.strftime('%Y')
  end
end
