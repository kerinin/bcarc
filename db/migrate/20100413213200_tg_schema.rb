=begin
class TgSchema < ActiveRecord::Migration
  def self.up
    create_table :blog_post do |t|
      t.integer :id
      t.integer :postid
      t.datetime :dateCreated
      t.text :permalink
      t.text :title
      t.text :description
      t.text :image
    end
    add_index :blog_post, :id
    
    create_table :image do |t|
      t.integer :id
      t.string :name
      t.integer :sequence_position
      t.text :description_en
      t.text :description_cn
      t.string :uri
      t.string :uri_large
      t.integer :plan_x
      t.integer :plan_y
      t.string :loc_a
      t.integer :plan_id
      t.boolean :sync_flickr
      t.integer :flickr_id
      t.integer :project_id
    end
    add_index :image, :id
    add_index :image, :plan_id
    add_index :image, :project_id
    
    #details omitted - will be dropped
    create_table :news_item

    create_table :page do |t|
      t.integer :id
      t.string :name
      t.text :splash_icon_uri
      t.integer :sequence_position
      t.text :content_en
      t.text :content_cn
    end
    add_index :page, :id
    
    create_table :plan do |t|
      t.integer :id
      t.string :uri
      t.text :name
      t.integer :sequence_position
      t.integer :project_id
    end
    add_index :plan, :id
    add_index :plan, :project_id
    
    create_table :project do |t|
      t.integer :id
      t.string :name
      t.text :short
      t.datetime :date_completed
      t.string :location
      t.text :description_en
      t.text :description_cn
      t.integer :priority
      t.integer :thumbnail_id
    end
    add_index :project, :id
    add_index :project, :thumbnail_id
    
    create_table :project_tag do |t|
      t.integer :project_id
      t.integer :tag_id
    end
    add_index :project_tag, :tag_id
    add_index :project_tag, :project_id
    
    create_table :tag do |t|
      t.integer :id
      t.string :name
      t.string :splash_icon_uri
      t.string :portfolio_default_image_uri
      t.string :portfolio_heading_text_uri
      t.string :name_text_uri
    end
    add_index :tag, :id
    
    #details omitted - will be dropped
    create_table :text
    
    create_table :video do |t|
      t.integer :id
      t.string :name
      t.integer :sequence_position
      t.text :description_en
      t.text :description_cn
      t.string :uri
      t.string '_thumb_uri'
      t.integer '_width'
      t.integer '_height'
      t.integer :project_id
    end
    add_index :video, :id
    add_index :video, :project_id
  end
  
  def self.down
    drop_table :blog_post
    drop_table :image
    drop_table :news_item
    drop_table :page
    drop_table :plan
    drop_table :project
    drop_table :project_tag
    drop_table :tag
    drop_table :text
    drop_table :video
  end
end
=end