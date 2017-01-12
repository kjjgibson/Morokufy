class CreateWebHookRules < ActiveRecord::Migration[5.0]
  def change
    create_table :web_hook_rules do |t|
      t.string :name
      t.references :web_hook, foreign_key: true
      t.timestamps
    end
  end
end
