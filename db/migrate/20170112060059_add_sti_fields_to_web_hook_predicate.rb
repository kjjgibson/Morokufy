class AddStiFieldsToWebHookPredicate < ActiveRecord::Migration[5.0]
  def change
    add_column :web_hook_predicates, :type, :string
    add_column :web_hook_predicates, :header, :string
    add_column :web_hook_predicates, :expected_values, :string
    add_column :web_hook_predicates, :path, :string

    remove_column :web_hook_predicates, :actable_id, :string
    remove_column :web_hook_predicates, :actable_type, :string
  end
end
