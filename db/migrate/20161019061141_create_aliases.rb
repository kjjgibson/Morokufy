class CreateAliases < ActiveRecord::Migration[5.0]
  def change
    create_table :aliases do |t|
      t.string :alias_type
      t.string :alias_value
      t.integer :player_id
      t.timestamps
    end
  end
end
