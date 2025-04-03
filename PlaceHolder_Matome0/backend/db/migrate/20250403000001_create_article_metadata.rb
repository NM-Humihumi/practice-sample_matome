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
  