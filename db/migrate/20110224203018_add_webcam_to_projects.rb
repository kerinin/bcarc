class AddWebcamToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :has_webcam, :boolean, :default => false
    add_column :projects, :webcam_current_url, :string
    add_column :projects, :webcam_ftp_dir, :string
    add_column :projects, :webcam_file_prefix, :string

    
    create_table :webcam_images do |i|
      i.datetime :date
      i.string :source_url

      i.string :attachment_file_name
      i.string :attachment_content_type
      i.integer :attachment_file_size
      i.datetime :attachment_updated_at
      
      i.belongs_to :project

      i.timestamps
    end
  end

  def self.down
    remove_column :projects, :has_webcam
    remove_column :projects, :webcam_current_url
    
    drop_table :webcam_images
  end
end
