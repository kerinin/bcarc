class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
    
    # generate the join table
    create_table :tags_projects, :id => false do |t|
      t.column :tag_id, :integer
      t.column :project_id, :integer
    end
    add_index "tags_projects", "tag_id"
    add_index "tags_projects", "project_id"
  end

  def self.down
    drop_table :tags
    drop_table :tags_projects
  end
end
