class CreateDiscussionMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :discussion_messages do |t|
      t.references :discussion, null: false, foreign_key: true
      t.integer :speaker_id, null: false  # AIキャラクターID
      t.text :content, null: false
      t.integer :position  # 表示順（1, 2, 3...）

      t.timestamps
    end

    add_index :discussion_messages, [:discussion_id, :position], unique: true
  end
end
