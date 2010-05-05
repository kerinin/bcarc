class AddProjectKeywords < ActiveRecord::Migration
  def self.up
    add_column :projects, :keywords, :string
  end

  def self.down
    remove_column :projects, :keywords
  end
end
