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
#  player_id       :integer
#
# Indexes
#
#  index_rule_consequent_events_on_player_id  (player_id)
#

# This class is used to record something 'interesting' happening on the Game Server as a consequent to logging an ExternalEvent
# Something 'interesting' means:
# * points awarded to the Player
# * achievements awarded to the Player
#
# Logging these consequents allows us to have a history of 'interesting' things happening

class RuleConsequentEvent < ApplicationRecord

  belongs_to :player

  validates_presence_of :consequent_type, :event_name, :player
  validates_presence_of :point_type, :point_count, if: lambda { |_| consequent_type == ConsequentType::POINTS_CONSEQUENT }
  validates_presence_of :achievement_id, if: lambda { |_| consequent_type == ConsequentType::ACHIEVEMENT_CONSEQUENT }
  validates_inclusion_of :consequent_type, in: lambda { |_| ConsequentType.constants.map { |c| ConsequentType.const_get(c) } }

  module ConsequentType
    POINTS_CONSEQUENT = 'points'
    ACHIEVEMENT_CONSEQUENT = 'achievement'
  end

end
