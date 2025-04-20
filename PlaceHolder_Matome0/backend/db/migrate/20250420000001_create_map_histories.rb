class CreateMapHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :map_histories do |t|
      t.references :map_tile, null: false, foreign_key: true
      t.string :change_type, null: false
      t.references :article, foreign_key: true
      t.datetime :changed_at, null: false

      t.timestamps
    end
  end
end
