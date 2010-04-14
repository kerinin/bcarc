class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :name
      t.integer :position
      t.text :description
      t.integer :width
      t.integer :height
      
      t.string :thumbnail_file_name
      t.string :thumbnail_content_type
      t.integer :thumbnail_file_size
      t.datetime :thumbnail_updated_at
      
      belongs_to :project

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
