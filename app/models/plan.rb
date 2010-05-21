class Plan < ActiveRecord::Base
  belongs_to :project
  
  has_many :images
  
  acts_as_list :scope => :project
  
  paperclip_params = YAML::load(File.open("#{RAILS_ROOT}/config/paperclip.yml"))[RAILS_ENV.to_sym]
  params = { :styles => { :thumb => '55x40#', :full => '800x800>'},
    :default_style => :index,
    :path => "projects/:id/plans/:style/:basename.:extension",
    }
    
  has_attached_file :attachment, ( paperclip_params ? params.merge(paperclip_params) : params )
  
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
