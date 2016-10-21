class ReplacePlayerNameAndEmailWithIdentifier < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :name, :string
    remove_column :players, :email, :string
    add_column :players, :identifier, :string
  end
end
