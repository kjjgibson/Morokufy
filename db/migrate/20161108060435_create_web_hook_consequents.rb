class CreateWebHookConsequents < ActiveRecord::Migration[5.0]
  def change
    create_table :web_hook_consequents do |t|
      t.references :web_hook_rule, foreign_key: true
      t.string :event_name
      t.timestamps
    end
  end
end
