class AddDefaults < ActiveRecord::Migration
  def self.up
    change_column :projects, :priority, :integer, :default => 5
  end

  def self.down
    change_column :projects, :priority, :integer, :default => nil
  end
end
