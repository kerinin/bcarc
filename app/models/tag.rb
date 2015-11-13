class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  
  before_save :handle_legacy_permalink
  
  #make_permalink :with => :name
  
  # extend FriendlyId
  # friendly_id :name, :use => :slugged
  
  validates_presence_of :name
  
  def self.by_name
    order(:name)
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
