class CreateWebHooks < ActiveRecord::Migration[5.0]
  def change
    create_table :web_hooks do |t|
      t.string :name
      t.string :request_url
      t.timestamps
    end
  end
end
