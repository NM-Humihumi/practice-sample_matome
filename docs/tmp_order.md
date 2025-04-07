# db/migrate/YYYYMMDDHHMMSS_create_articles.rb
class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content
      t.string :slug, null: false
      t.string :status, default: 'draft'
      t.string :category
      t.string :author
      t.datetime :published_at

      t.timestamps
    end

    add_index :articles, :slug, unique: true
    add_index :articles, :published_at
    add_index :articles, :status
    add_index :articles, :category
  end
end


# db/migrate/YYYYMMDDHHMMSS_create_article_metadata.rb
class CreateArticleMetadata < ActiveRecord::Migration[6.1]
  def change
    create_table :article_metadata do |t|
      t.references :article, null: false, foreign_key: true
      t.text :summary
      t.string :image_url
      t.string :thumbnail_url
      t.string :tags
      t.integer :view_count, default: 0
      t.integer :reading_time # 読了時間の目安（分）
      t.boolean :featured, default: false
      t.boolean :comment_enabled, default: true
      t.string :meta_title
      t.text :meta_description
      t.string :source_url
      t.boolean :is_premium, default: false
      t.integer :published_by
      t.integer :last_modified_by

      t.timestamps
    end

    add_index :article_metadata, :featured
    add_index :article_metadata, :is_premium
    add_index :article_metadata, :view_count
  end
end