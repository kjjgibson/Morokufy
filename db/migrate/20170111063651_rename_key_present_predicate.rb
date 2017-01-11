class RenameKeyPresentPredicate < ActiveRecord::Migration[5.0]
  def change
    rename_table :key_present_predicates, :json_path_has_result_predicates
  end
end
