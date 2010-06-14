class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  
  make_permalink :with => :name
  
  validates_presence_of :name
  
  named_scope :by_name, :order => 'name'
  
  #translates :name
  
  private
  
  def save_permalink
    return unless I18n.locale == :en
    super
  end
end
