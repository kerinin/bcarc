class Page < ActiveRecord::Base
  has_permalink :name
  
  acts_as_wikitext :content
  
  def to_param
    permalink
  end
end
