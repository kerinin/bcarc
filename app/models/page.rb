class Page < ActiveRecord::Base
  before_save :handle_legacy_permalink
  #make_permalink :with => :name
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  
  acts_as_list
  
  translates :content
  
  default_scope :order => 'position ASC'
  
  validates_presence_of :name
  
  scope :by_position, lambda { order(:position) }
  #named_scope :by_position, :order => 'position'
  
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
