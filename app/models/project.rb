class Project < ActiveRecord::Base  
  has_many :images
  has_many :videos
  has_many :plans
  
  belongs_to :thumbnail, :class_name => 'Image'
  
  has_and_belongs_to_many :tags
end
