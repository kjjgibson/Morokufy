class RenameValueMatchesPredicateToJsonPathResultMatchesPredicate < ActiveRecord::Migration[5.0]
  def change
    rename_table :value_matches_predicates, :json_path_result_matches_predicates
  end
end
