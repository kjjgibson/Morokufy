class CreateJsonPathPredicates < ActiveRecord::Migration[5.0]
  def change
    create_table :json_path_predicates do |t|
      t.string :path
    end
  end
end
