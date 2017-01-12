class DropMtiPredicateTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :header_matches_predicates do |t|
      t.string :header
      t.string :expected_value
    end

    drop_table :json_path_has_result_predicates do |t|
    end

    drop_table :json_path_predicates do |t|
      t.string :path
      t.integer :jpp_actable_id
      t.string :jpp_actable_type
    end

    drop_table :json_path_result_includes_all_predicates do |t|
      t.string :expected_values
    end

    drop_table :json_path_result_includes_any_predicates do |t|
      t.string :expected_values
    end

    drop_table :json_path_result_matches_predicates do |t|
      t.string :expected_values
    end
  end
end
