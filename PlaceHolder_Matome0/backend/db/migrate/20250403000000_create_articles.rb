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