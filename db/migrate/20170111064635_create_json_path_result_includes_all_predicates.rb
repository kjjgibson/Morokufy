class CreateJsonPathResultIncludesAllPredicates < ActiveRecord::Migration[5.0]
  def change
    create_table :json_path_result_includes_all_predicates do |t|
      t.string :expected_values
    end
  end
end
