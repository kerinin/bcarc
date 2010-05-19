class AddProjectsFlickrId < ActiveRecord::Migration
  def self.up
    add_column :projects, :flickr_id, :string
  end

  def self.down
    remove_column :projects, :flickr_id
  end
end
