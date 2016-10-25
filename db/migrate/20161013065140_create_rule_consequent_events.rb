class CreateRuleConsequentEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :rule_consequent_events do |t|
      t.string :consequent_type
      t.integer :achievement_id
      t.string :point_type
      t.integer :point_count
      t.string :event_name
      t.timestamps
    end
  end
end
