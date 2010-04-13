class Project < ActiveRecord::Base
  belongs_to :image, :as => :thumbnail
  
  has_many :images
  has_many :videos
  has_many :plans
  
  has_and_belongs_to_many :tags
end
