class Image < ActiveRecord::Base
  has_attached_file :attachment, 
    :styles => { 
      :thumb => '55x40#', 
      :thumb_ds => { :geometry => '55x40#', :processors => [:thumbnail, :modulate], :saturation => 0 },
      :index => '390x180#', 
      :full => '800x800>'
    }, 
    :default_style => :index,
    :url => ":s3_alias_url",
    :path => "projects/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :s3_host_alias => "assets.bcarc.com",
    :bucket => 'assets.bcarc.com'
                      
  belongs_to :project
  
  validates_attachment_presence :attachment
  
  #translates :name, :description
  
  acts_as_list :scope => :project
  
  def html_description
    #Wikitext::Parser.new().parse( description.to_s )
    return nil if description.empty?
    
    RedCloth.new( description ).to_html
  end
  
  def upload_to_s3
    if self.attachment_file_size.nil?
      begin
        self.attachment = File.new(self.attachment_file_name)
        self.save!
      rescue
        puts "FAIL!!!  #{self.id}"
      else
        puts self.id
      end
    end
  end
  
  def destroy
    self.deleted_at = Time.now
    self.save!
  end
end
