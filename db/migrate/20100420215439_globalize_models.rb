class GlobalizeModels < ActiveRecord::Migration
  def self.up
    Image.create_translation_table! :name => :string, :description => :text
    Page.create_translation_table! :name => :string, :content => :text
    Plan.create_translation_table! :name => :string
    Project.create_translation_table! :name => :string, :short => :text, :description => :text
    Tag.create_translation_table! :name => :string
    Video.create_translation_table! :name => :string, :description => :text
  end

  def self.down
    Image.drop_translation_table!
    Page.drop_translation_table!
    Plan.drop_translation_table!
    Project.drop_translation_table!
    Tag.drop_translation_table!
    Video.drop_translation_table!
  end
end
