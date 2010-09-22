class AddTranslationTables < ActiveRecord::Migration
  def self.up
    Project.create_translation_table! :short => :text, :description => :text
    Page.create_translation_table! :content => :text
  end

  def self.down
    Project.drop_translation_table!
    Page.drop_translation_table!
  end
end
