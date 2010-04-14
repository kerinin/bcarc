class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.text :short
      t.datetime :date_completed
      t.string :location
      t.text :description
      t.integer :priority
            
      t.belongs_to :thumbnail

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
