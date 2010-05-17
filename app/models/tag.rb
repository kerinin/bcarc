class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  
  make_permalink :with => :name
  
  validates_presence_of :name
  
  #translates :name
end
