class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :status, default: 'draft'
      t.string :author
      t.datetime :published_at
      t.text :digest, null: false

      t.timestamps
    end

    add_index :articles, :slug, unique: true
    add_index :articles, :published_at
    add_index :articles, :status
  end
end
