class AddApiKeyAndSecretToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :api_key, :string
    add_column :players, :shared_secret, :string
  end
end
