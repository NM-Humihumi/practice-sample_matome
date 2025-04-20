class CreateMapTiles < ActiveRecord::Migration[6.0]
  def change
    create_table :map_tiles do |t|
      t.integer :x, null: false
      t.integer :y, null: false
      t.string :name
      t.string :tile_type, null: false
      t.string :owner

      t.index [:x, :y], unique: true

      t.timestamps
    end
  end
end
