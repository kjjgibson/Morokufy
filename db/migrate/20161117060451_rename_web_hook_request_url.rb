class RenameWebHookRequestUrl < ActiveRecord::Migration[5.0]
  def change
    rename_column :web_hooks, :request_url, :source_identifier
  end
end
