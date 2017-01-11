class RenameExpectedValues < ActiveRecord::Migration[5.0]
  def change
    rename_column :json_path_result_matches_predicates, :expected_value, :expected_values
  end
end
