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

ActiveRecord::Schema[7.1].define(version: 2025_04_20_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_categories", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id", "category_id"], name: "index_article_categories_on_article_id_and_category_id", unique: true
    t.index ["article_id"], name: "index_article_categories_on_article_id"
    t.index ["category_id"], name: "index_article_categories_on_category_id"
  end

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
    t.string "slug", null: false
    t.string "status", default: "draft"
    t.string "author"
    t.datetime "published_at", precision: nil
    t.text "digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["published_at"], name: "index_articles_on_published_at"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
    t.index ["status"], name: "index_articles_on_status"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "discussion_messages", force: :cascade do |t|
    t.bigint "discussion_id", null: false
    t.integer "speaker_id", null: false
    t.text "content", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_id", "position"], name: "index_discussion_messages_on_discussion_id_and_position", unique: true
    t.index ["discussion_id"], name: "index_discussion_messages_on_discussion_id"
  end

  create_table "discussions", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_discussions_on_article_id"
  end

  create_table "map_histories", force: :cascade do |t|
    t.bigint "map_tile_id", null: false
    t.string "change_type", null: false
    t.bigint "article_id"
    t.datetime "changed_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_map_histories_on_article_id"
    t.index ["map_tile_id"], name: "index_map_histories_on_map_tile_id"
  end

  create_table "map_tiles", force: :cascade do |t|
    t.integer "x", null: false
    t.integer "y", null: false
    t.string "name"
    t.string "tile_type", null: false
    t.string "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["x", "y"], name: "index_map_tiles_on_x_and_y", unique: true
  end

  create_table "raw_news", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.string "source_url"
    t.string "image_url"
    t.datetime "published_at", precision: nil
    t.string "author"
    t.string "external_id", null: false
    t.string "source_type", default: "newscast", null: false
    t.boolean "converted_to_article", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_raw_news_on_external_id", unique: true
  end

  create_table "speakers", force: :cascade do |t|
    t.string "name", null: false
    t.string "display_name"
    t.string "color_code"
    t.string "default_icon_url"
    t.string "character_sheet_url"
    t.string "joy_icon_url"
    t.string "anger_icon_url"
    t.string "sadness_icon_url"
    t.string "pleasure_icon_url"
    t.string "surprise_icon_url"
    t.string "fear_icon_url"
    t.string "envy_icon_url"
    t.string "shame_icon_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "article_categories", "articles"
  add_foreign_key "article_categories", "categories"
  add_foreign_key "article_metadata", "articles"
  add_foreign_key "discussion_messages", "discussions"
  add_foreign_key "discussions", "articles"
  add_foreign_key "map_histories", "articles"
  add_foreign_key "map_histories", "map_tiles"
end
