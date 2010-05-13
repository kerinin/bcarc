class AddProjectsMap < ActiveRecord::Migration
  def self.up
    add_column :projects, :show_map, :boolean, :default => false
    add_column :projects, :map_accuracy, :integer
  end

  def self.down
    remove_column :projects, :show_map
    remove_column :projects, :map_accuracy
  end
end
