def create_event_created_rule(rule_name, event_name)
  r = Rule.find_or_initialize_by(name: rule_name)
  p = r.predicate
  if !p
    p = EventCreatedPredicate.new
    r.predicate = p
  end
  p.event_type = event_name
  p.save!
  r.save!

  return r
end

def create_event_initial_rule(rule_name, event_name, target)
  r = Rule.find_or_initialize_by(name: rule_name)
  p = r.predicate
  if !p
    p = EventInitialPredicate.new
    r.predicate = p
  end
  p.event_type = event_name
  p.target = target
  p.save!
  r.save!

  return r
end

def create_points_consequents(rule, points)
  Consequent.where(rule_id: rule.id).delete_all

  points.each do |point|
    c = PointsConsequent.new
    c.point_type = PointType.find_by_name!(point[:name])
    c.points = point[:count]
    c.rule_id = rule.id
    c.save!
  end
end

def create_achievement_consequents(rule, achievement_names)
  Consequent.where(rule_id: rule.id).delete_all

  achievement_names.each do |achievement_name|
    c = AchievementConsequent.new
    c.achievement = Achievement.find_by_name!(achievement_name)
    c.rule_id = rule.id
    c.save!
  end
end

Rule.transaction do
  #============== Semaphore ==============
  r = create_event_created_rule('Semaphore Failed Build', 'SemaphoreBuildFailed')
  create_points_consequents(r, [{ name: 'Points', count: -10 }])

  r = create_event_created_rule('Semaphore Successful Build', 'SemaphoreBuildPassed')
  create_points_consequents(r, [{ name: 'Points', count: 10 }, { name: 'Exp', count: 100 }])

  r = create_event_initial_rule('One Successful Semaphore Build', 'SemaphoreBuildPassed', 1)
  create_achievement_consequents(r, ['Does it Work?'])
  r = create_event_initial_rule('Five Successful Semaphore Builds', 'SemaphoreBuildPassed', 5)
  create_achievement_consequents(r, ['Testing the Waters'])
  r = create_event_initial_rule('Ten Successful Semaphore Builds', 'SemaphoreBuildPassed', 10)
  create_achievement_consequents(r, ['Testing Your Skill'])
  r = create_event_initial_rule('Twenty Successful Semaphore Builds', 'SemaphoreBuildPassed', 20)
  create_achievement_consequents(r, ['A Tester\'s Courage'])
  r = create_event_initial_rule('Forty Successful Semaphore Builds', 'SemaphoreBuildPassed', 40)
  create_achievement_consequents(r, ['Quality Assured'])
  r = create_event_initial_rule('Eighty Successful Semaphore Builds', 'SemaphoreBuildPassed', 80)
  create_achievement_consequents(r, ['Can\'t Test This!'])
  r = create_event_initial_rule('Two Hundred Successful Semaphore Builds', 'SemaphoreBuildPassed', 200)
  create_achievement_consequents(r, ['Green for Miles'])
  r = create_event_initial_rule('One Failed Semaphore Build', 'SemaphoreBuildFailed', 1)
  create_achievement_consequents(r, ['It Worked On MY Machine'])
  r = create_event_initial_rule('Five Failed Semaphore Builds', 'SemaphoreBuildFailed', 5)
  create_achievement_consequents(r, ['Testing Your Patience'])
  #=======================================

  #============== BitBucket ==============
  r = create_event_created_rule('Bitbucket Repository Push', 'BitbucketRepositoryPush')
  create_points_consequents(r, [{ name: 'Points', count: 5 }, { name: 'Exp', count: 50 }])

  #=======================================
end
