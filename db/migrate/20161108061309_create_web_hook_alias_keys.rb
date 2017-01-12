class CreateWebHookAliasKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :web_hook_alias_keys do |t|
      t.references :web_hook, foreign_key: true
      t.string :alias_key
      t.string :alias_type
      t.timestamps
    end
  end
end
