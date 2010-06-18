class AddProjectHasTags < ActiveRecord::Migration
  def self.up
    add_column :projects, :has_tags, :boolean
  end

  def self.down
    remove_column :projects, :has_tags
  end
end
