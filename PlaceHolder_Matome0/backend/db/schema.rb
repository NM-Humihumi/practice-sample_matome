# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_04_03_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_metadata", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.text "summary"
    t.string "image_url"
    t.string "thumbnail_url"
    t.string "tags"
    t.integer "view_count", default: 0
    t.integer "reading_time"
    t.boolean "featured", default: false
    t.boolean "comment_enabled", default: true
    t.string "meta_title"
    t.text "meta_description"
    t.string "source_url"
    t.boolean "is_premium", default: false
    t.integer "published_by"
    t.integer "last_modified_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_metadata_on_article_id"
    t.index ["featured"], name: "index_article_metadata_on_featured"
    t.index ["is_premium"], name: "index_article_metadata_on_is_premium"
    t.index ["view_count"], name: "index_article_metadata_on_view_count"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.string "slug", null: false
    t.string "status", default: "draft"
    t.string "category"
    t.string "author"
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_articles_on_category"
    t.index ["published_at"], name: "index_articles_on_published_at"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
    t.index ["status"], name: "index_articles_on_status"
  end

  add_foreign_key "article_metadata", "articles"
end
