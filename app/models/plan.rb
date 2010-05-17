class Plan < ActiveRecord::Base
  belongs_to :project
  
  has_many :images
  
  acts_as_list :scope => :project
  
  has_attached_file :attachment, 
    :styles => { :thumb => '55x40#', :full => '800x800>'},
    :default_style => :index,
    :url => ":s3_alias_url",
    :path => "projects/:id/plans/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :s3_host_alias => "assets.bcarc.com",
    :bucket => 'assets.bcarc.com',
    :s3_headers => {'Cache-Control' => 'max-age=31557600'}
    
  validates_attachment_presence :attachment
  validates_presence_of :name, :project_id
  
  #translates :name
  
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
