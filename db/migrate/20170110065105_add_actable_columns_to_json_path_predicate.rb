class AddActableColumnsToJsonPathPredicate < ActiveRecord::Migration[5.0]
  def change
    add_column :json_path_predicates, :jpp_actable_id, :integer
    add_column :json_path_predicates, :jpp_actable_type, :string
  end
end
