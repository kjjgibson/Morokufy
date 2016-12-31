class CreateHeaderMatchesPredicates < ActiveRecord::Migration[5.0]
  def change
    create_table :header_matches_predicates do |t|
      t.string :header
      t.string :expected_value
    end
  end
end
