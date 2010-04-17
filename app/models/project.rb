class Project < ActiveRecord::Base  
  has_many :images, :order => 'position'
  has_many :videos, :order => 'position'
  has_many :plans, :order => 'position'
  
  belongs_to :thumbnail, :class_name => 'Image'
  
  has_and_belongs_to_many :tags
  
  acts_as_wikitext :description
  
  def year
    self.date_completed.strftime('%Y')
  end
end
