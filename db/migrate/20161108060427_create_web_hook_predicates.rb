class CreateWebHookPredicates < ActiveRecord::Migration[5.0]
  def change
    create_table :web_hook_predicates do |t|
      t.references :web_hook_rule, foreign_key: true
      t.string :web_hook_key
      t.string :expected_value
      t.timestamps
    end
  end
end
