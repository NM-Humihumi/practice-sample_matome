class CreateSpeakers < ActiveRecord::Migration[6.1]
  def change
    create_table :speakers do |t|
      t.string :name, null: false                     # 内部名（識別用）
      t.string :display_name                         # 表示用名称 ← 追加！
      t.string :color_code                           # 発言の色などに使える
      t.string :default_icon_url
      t.string :character_sheet_url

      # 感情別アイコン（null可、なければdefault_icon_urlを使う）
      t.string :joy_icon_url         # 喜
      t.string :anger_icon_url       # 怒
      t.string :sadness_icon_url     # 哀
      t.string :pleasure_icon_url    # 楽
      t.string :surprise_icon_url    # 驚
      t.string :fear_icon_url        # 恐
      t.string :envy_icon_url        # 嫉
      t.string :shame_icon_url       # 恥

      t.timestamps
    end
  end
end
