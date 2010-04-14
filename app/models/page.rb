class Page < ActiveRecord::Base
  acts_as_wikitext :content
end
