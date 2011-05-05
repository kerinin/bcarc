class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  
  before_save :handle_legacy_permalink
  
  make_permalink :with => :name
  
  validates_presence_of :name
  
  scope :by_name, lambda { order(:name) }
  #named_scope :by_name, :order => 'name'
  
  #translates :name
  
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
