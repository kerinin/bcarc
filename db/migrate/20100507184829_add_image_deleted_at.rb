class AddImageDeletedAt < ActiveRecord::Migration
  def self.up
    add_column :images, :deleted_at, :datetime
  end

  def self.down
    remove_column :images, :deleted_at
  end
end
