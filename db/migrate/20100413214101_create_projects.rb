class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.text :short
      t.datetime :date_completed
      t.string :location
      t.text :description
      t.integer :priority

      t.string :thumbnail_file_name
      t.string :thumbnail_content_type
      t.integer :thumbnail_file_size
      t.datetime :thumbnail_updated_at
            
      belongs_to :image, :as => :thumbnail_id

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
