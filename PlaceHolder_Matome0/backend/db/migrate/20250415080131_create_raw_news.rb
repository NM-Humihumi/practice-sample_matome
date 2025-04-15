class CreateRawNews < ActiveRecord::Migration[6.0]
  def change
    create_table :raw_news do |t|
      t.string :title, null: false
      t.text :body
      t.string :source_url
      t.string :image_url
      t.datetime :published_at
      t.string :author
      t.string :external_id, null: false
      t.string :source_type, null: false, default: 'newscast'
      t.boolean :converted_to_article, default: false

      t.timestamps
    end

    add_index :raw_news, :external_id, unique: true
  end
end
