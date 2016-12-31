class AddActableColumnsToWebHookPredicates < ActiveRecord::Migration[5.0]
  def change
    add_column :web_hook_predicates, :actable_id, :integer
    add_column :web_hook_predicates, :actable_type, :string
  end
end
