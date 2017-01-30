FactoryGirl.define do
  factory :rule_consequent_event do
    player
    event_name 'EventName'

    trait :point_consequent do
      consequent_type RuleConsequentEvent::ConsequentType::POINTS_CONSEQUENT
      point_type 'Points'
      point_count 10
    end

    trait :achievement_consequent do
      consequent_type RuleConsequentEvent::ConsequentType::ACHIEVEMENT_CONSEQUENT
      achievement_id 1
    end
  end
end
