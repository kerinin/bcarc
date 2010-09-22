class AddLegacyPermalinks < ActiveRecord::Migration
  def self.up
    add_column :pages, :legacy_permalinks, :string
    add_column :projects, :legacy_permalinks, :string
    add_column :tags, :legacy_permalinks, :string
    
    add_index :pages, :legacy_permalinks
    add_index :projects, :legacy_permalinks
    add_index :tags, :legacy_permalinks
  end

  def self.down
    remove_column :pages, :legacy_permalinks
    remove_column :projects, :legacy_permalinks
    remove_column :tags, :legacy_permalinks
    
    remove_index :pages, :legacy_permalinks
    remove_index :projects, :legacy_permalinks
    remove_index :tags, :legacy_permalinks
  end
end
