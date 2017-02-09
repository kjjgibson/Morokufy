class AddPlayersToRuleConsequentEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :rule_consequent_events, :player, index: true
  end
end
