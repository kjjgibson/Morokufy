class CreateValueMatchesPredicates < ActiveRecord::Migration[5.0]
  def change
    create_table :value_matches_predicates do |t|
      t.string :expected_value
    end
  end
end
