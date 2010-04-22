class AddProjectGeolocation < ActiveRecord::Migration
  def self.up
    add_column :projects, :latitude, :float
    add_column :projects, :longitude, :float
    add_column :projects, :address, :string
    add_column :projects, :city, :string
    add_column :projects, :state, :string
    
    remove_column :projects, :location
  end

  def self.down
    remove_column :projects, :latitude
    remove_column :projects, :longitude
    remove_column :projects, :address
    remove_column :projects, :city
    remove_column :projects, :state
    
    add_column :projects, :location, :string
  end
end
