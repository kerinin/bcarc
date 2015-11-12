# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20110513164422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.text     "description"
    t.integer  "plan_x"
    t.integer  "plan_y"
    t.integer  "locator_angle"
    t.boolean  "sync_flickr"
    t.string   "flickr_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "plan_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "images", ["project_id"], name: "index_images_on_project_id", using: :btree

  create_table "page_translations", force: :cascade do |t|
    t.integer  "page_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "content"
  end

  add_index "page_translations", ["locale"], name: "index_page_translations_on_locale", using: :btree
  add_index "page_translations", ["page_id"], name: "index_page_translations_on_page_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.string   "legacy_permalinks"
  end

  add_index "pages", ["legacy_permalinks"], name: "index_pages_on_legacy_permalinks", using: :btree
  add_index "pages", ["permalink"], name: "index_pages_on_permalink", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["project_id"], name: "index_plans_on_project_id", using: :btree

  create_table "project_translations", force: :cascade do |t|
    t.integer  "project_id",  null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "short"
    t.text     "description"
  end

  add_index "project_translations", ["locale"], name: "index_project_translations_on_locale", using: :btree
  add_index "project_translations", ["project_id"], name: "index_project_translations_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "short"
    t.datetime "date_completed"
    t.text     "description"
    t.integer  "priority",           default: 5
    t.integer  "thumbnail_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "keywords"
    t.boolean  "show_map",           default: false
    t.integer  "map_accuracy"
    t.string   "flickr_id"
    t.boolean  "has_tags"
    t.string   "legacy_permalinks"
    t.boolean  "has_webcam",         default: false
    t.string   "webcam_current_url"
    t.string   "webcam_ftp_dir"
    t.string   "webcam_file_prefix"
  end

  add_index "projects", ["legacy_permalinks"], name: "index_projects_on_legacy_permalinks", using: :btree
  add_index "projects", ["permalink"], name: "index_projects_on_permalink", using: :btree

  create_table "projects_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "project_id"
  end

  add_index "projects_tags", ["project_id"], name: "index_projects_tags_on_project_id", using: :btree
  add_index "projects_tags", ["tag_id"], name: "index_projects_tags_on_tag_id", using: :btree

  create_table "slugs", force: :cascade do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                  default: 1, null: false
    t.string   "sluggable_type", limit: 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], name: "index_slugs_on_n_s_s_and_s", unique: true, using: :btree
  add_index "slugs", ["sluggable_id"], name: "index_slugs_on_sluggable_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.string   "legacy_permalinks"
  end

  add_index "tags", ["legacy_permalinks"], name: "index_tags_on_legacy_permalinks", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.text     "description"
    t.integer  "width"
    t.integer  "height"
    t.string   "uri"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["project_id"], name: "index_videos_on_project_id", using: :btree

  create_table "webcam_images", force: :cascade do |t|
    t.datetime "date"
    t.string   "source_url"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "daily_image"
  end

end
