class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  
  has_permalink :name
  
  def to_param
    permalink
  end
end
