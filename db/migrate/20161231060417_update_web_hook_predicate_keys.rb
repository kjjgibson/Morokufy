class UpdateWebHookPredicateKeys < ActiveRecord::Migration[5.0]
  def change
    remove_column :web_hook_predicates, :expected_value, :string
    rename_column :web_hook_predicates, :web_hook_key, :key_path
  end
end
