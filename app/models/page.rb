class Page < ActiveRecord::Base
  attr_accessor :name, :position, :content

  before_save :handle_legacy_permalink
  #make_permalink :with => :name

  # extend FriendlyId
  # friendly_id :name, :use => :slugged
  
  acts_as_list
  
  translates :content
  
  validates_presence_of :name
  
  def self.default_scope
    order(:position)
  end

  def self.by_position
    order(:position)
  end
  
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
  
  def handle_legacy_permalink 
    if self.name_changed?
      self.legacy_permalinks = [self.legacy_permalinks, self.to_param].join(' ').strip
    end
  end
end
