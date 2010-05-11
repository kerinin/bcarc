class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :images, :project_id
    add_index :pages, :permalink
    add_index :plans, :project_id
    add_index :projects, :permalink
    add_index :videos, :project_id
  end

  def self.down
    remove_index :images, :project_id
    remove_index :pages, :permalink
    remove_index :plans, :project_id
    remove_index :projects, :permalink
    remove_index :videos, :project_id
  end
end
