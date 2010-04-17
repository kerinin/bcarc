class Page < ActiveRecord::Base
  has_permalink :name
  
  acts_as_wikitext :content
  
  acts_as_list
  
  default_scope :order => 'position ASC'
    
  def to_param
    permalink
  end
end
