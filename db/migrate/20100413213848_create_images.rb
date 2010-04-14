class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :name
      t.integer :position
      t.text :description
      t.integer :plan_x
      t.integer :plan_y
      t.integer :locator_angle
      t.boolean :sync_flickr
      t.string :flickr_id

      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      
      belongs_to :plan, :project

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
