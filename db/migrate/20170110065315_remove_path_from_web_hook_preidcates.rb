class RemovePathFromWebHookPreidcates < ActiveRecord::Migration[5.0]
  def change
    remove_column :web_hook_predicates, :key_path, :string
  end
end
