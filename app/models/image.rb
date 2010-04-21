class Image < ActiveRecord::Base
  has_attached_file :attachment, 
    :styles => { 
      :thumb => '55x40#', 
      :thumb_ds => { :geometry => '55x40#', :processors => [:thumbnail, :modulate], :saturation => 0 },
      :index => '390x180#', 
      :full => '800x800>'
    }, 
    :default_style => :index,
    :url => "/assets/projects/:id/:style/:basename.:extension",
    :path => "projects/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :bucket => 'bcstudio'
                      
  belongs_to :project
  
  translates :name, :description
  
  acts_as_wikitext :description
  
  acts_as_list :scope => :project
  
  def html_description
    Wikitext::Parser.new().parse( description.to_s )
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
end
