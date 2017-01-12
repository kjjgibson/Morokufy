class AddPredicate1And2ToWebHookPredicate < ActiveRecord::Migration[5.0]
  def change
    add_column :web_hook_predicates, :predicate1_id, :integer
    add_column :web_hook_predicates, :predicate2_id, :integer
  end
end
