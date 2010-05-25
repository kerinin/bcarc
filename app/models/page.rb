class Page < ActiveRecord::Base
  make_permalink :with => :name
  
  acts_as_list
  
  translates :name, :content
  
  default_scope :order => 'position ASC'
  
  validates_presence_of :name
  
  def html_content
    #Wikitext::Parser.new().parse( content.to_s )
    return nil unless content
    
    RedCloth.new( content ).to_html
  end
  
  private
  
  def save_permalink
    return unless I18n.locale == :en
    super
  end
end
