# == Schema Information
#
# Table name: rule_consequent_events
#
#  id              :integer          not null, primary key
#  consequent_type :string
#  achievement_id  :integer
#  point_type      :string
#  point_count     :integer
#  event_name      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# This class is used to record something 'interesting' happening on the Game Server as a consequent to logging an ExternalEvent
# Something 'interesting' means:
# * points awarded to the Player
# * achievements awarded to the Player
#
# Logging these consequents allows us to have a history of 'interesting' things happening

class RuleConsequentEvent < ApplicationRecord

  module ConsequentType
    POINTS_CONSEQUENT = 'points'
    ACHIEVEMENT_CONSEQUENT = 'achievement'
  end

end
