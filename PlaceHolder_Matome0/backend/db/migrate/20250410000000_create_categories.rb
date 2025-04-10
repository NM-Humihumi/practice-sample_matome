class CreateCategories < ActiveRecord::Migration[6.1]
    def change
      create_table :categories do |t|
        t.string :name, null: false                # 表示用のカテゴリ名（例: テクノロジー）
        t.string :slug, null: false, unique: true  # URL等で使う識別子（例: technology）
        t.text :description                        # カテゴリの簡単な説明（任意）
  
        t.timestamps
      end
  
      add_index :categories, :slug, unique: true
      add_index :categories, :name
    end
  end