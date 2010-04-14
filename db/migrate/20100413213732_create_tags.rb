class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
    
    # generate the join table
    create_table :projects_tags, :id => false do |t|
      t.column :tag_id, :integer
      t.column :project_id, :integer
    end
    add_index "projects_tags", "tag_id"
    add_index "projects_tags", "project_id"
  end

  def self.down
    drop_table :tags
    drop_table :tags_projects
  end
end
