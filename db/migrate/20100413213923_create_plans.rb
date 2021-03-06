class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :name
      t.integer :position

      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
            
      t.belongs_to :project

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
