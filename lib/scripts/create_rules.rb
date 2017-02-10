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

def create_points_rule(rule_name, event_name, points)
  r = create_event_created_rule(rule_name, event_name)
  create_points_consequents(r, points)
end

def create_achievement_rule(rule_name, event_name, target, achievement_name)
  r = create_event_initial_rule(rule_name, event_name, target)
  create_achievement_consequents(r, [achievement_name])
end

Rule.transaction do
  #============== Semaphore ==============
  create_points_rule('Semaphore Failed Build', 'SemaphoreBuildFailed', [{ name: 'Points', count: -10 }])
  create_points_rule('Semaphore Successful Build', 'SemaphoreBuildPassed', [{ name: 'Points', count: 10 }, { name: 'Exp', count: 100 }])

  create_achievement_rule('One Successful Semaphore Build', 'SemaphoreBuildPassed', 1, 'Does it Work?')
  create_achievement_rule('Five Successful Semaphore Builds', 'SemaphoreBuildPassed', 5, 'Testing the Waters')
  create_achievement_rule('Ten Successful Semaphore Builds', 'SemaphoreBuildPassed', 10, 'Testing Your Skill')
  create_achievement_rule('Twenty Successful Semaphore Builds', 'SemaphoreBuildPassed', 20, 'A Tester\'s Courage')
  create_achievement_rule('Forty Successful Semaphore Builds', 'SemaphoreBuildPassed', 40, 'Quality Assured')
  create_achievement_rule('Eighty Successful Semaphore Builds', 'SemaphoreBuildPassed', 80, 'Can\'t Test This!')
  create_achievement_rule('Two Hundred Successful Semaphore Builds', 'SemaphoreBuildPassed', 200, 'Green for Miles')
  create_achievement_rule('One Failed Semaphore Build', 'SemaphoreBuildFailed', 1, 'It Worked On MY Machine')
  create_achievement_rule('Five Failed Semaphore Builds', 'SemaphoreBuildFailed', 5, 'Testing Your Patience')
  #=======================================

  #============== BitBucket ==============
  create_points_rule('Bitbucket Repository Push', 'BitbucketRepositoryPush', [{ name: 'Points', count: 5 }, { name: 'Exp', count: 50 }])
  create_points_rule('Bitbucket PR Created', 'BitbucketPullRequestCreated', [{ name: 'Points', count: 10 }, { name: 'Exp', count: 100 }])
  create_points_rule('Bitbucket PR Updated', 'BitbucketPullRequestUpdated', [{ name: 'Points', count: 1 }, { name: 'Exp', count: 10 }])
  create_points_rule('Bitbucket PR Approved', 'BitbucketPullRequestApproved', [{ name: 'Points', count: 1 }, { name: 'Exp', count: 10 }])
  create_points_rule('Bitbucket PR Merged', 'BitbucketPullRequestMerged', [{ name: 'Points', count: 50 }, { name: 'Exp', count: 500 }])
  create_points_rule('Bitbucket Comment Created', 'BitbucketPullRequestCommentCreated', [{ name: 'Points', count: 2 }, { name: 'Exp', count: 20 }])

  create_achievement_rule('One Bitbucket Repository Push', 'BitbucketRepositoryPush', 1, 'First Push')
  create_achievement_rule('Five Bitbucket Repository Pushes', 'BitbucketRepositoryPush', 5, 'Pushing Uphill')
  create_achievement_rule('Ten Bitbucket Repository Pushes', 'BitbucketRepositoryPush', 10, 'Push the Button')
  create_achievement_rule('Twenty Bitbucket Repository Pushes', 'BitbucketRepositoryPush', 20, 'Blind Pusher')
  create_achievement_rule('Forty Bitbucket Repository Pushes', 'BitbucketRepositoryPush', 40, 'Push Apprentice')
  create_achievement_rule('Eighty Bitbucket Repository Pushes', 'BitbucketRepositoryPush', 80, 'Push Expert')
  create_achievement_rule('Two Hundred Bitbucket Repository Pushes', 'BitbucketRepositoryPush', 200, 'Push Master')

  create_achievement_rule('One Bitbucket PR Created', 'BitbucketPullRequestCreated', 1, 'Please Be Gentle')
  create_achievement_rule('Five Bitbucket PRs Created', 'BitbucketPullRequestCreated', 5, 'Review Me!')
  create_achievement_rule('Ten Bitbucket PRs Created', 'BitbucketPullRequestCreated', 10, 'Criticism Welcome')
  create_achievement_rule('Twenty Bitbucket PRs Created', 'BitbucketPullRequestCreated', 20, 'Review Guru')
  create_achievement_rule('Forty Bitbucket PRs Created', 'BitbucketPullRequestCreated', 40, 'Review My Sexy Code')
  create_achievement_rule('Eighty Bitbucket PRs Created', 'BitbucketPullRequestCreated', 80, 'Nothing to Say?')
  create_achievement_rule('Two Hundred Bitbucket PRs Created', 'BitbucketPullRequestCreated', 200, 'Look at this Perfect Code')

  create_achievement_rule('One Bitbucket PR Merged', 'BitbucketPullRequestMerged', 1, 'First Merge')
  create_achievement_rule('Five Bitbucket PRs Merged', 'BitbucketPullRequestMerged', 5, 'Make Way for My Merge')
  create_achievement_rule('Ten Bitbucket PRs Merged', 'BitbucketPullRequestMerged', 10, 'Fork in the Road')
  create_achievement_rule('Twenty Bitbucket PRs Merged', 'BitbucketPullRequestMerged', 20, 'Branch Shredder')
  create_achievement_rule('Forty Bitbucket PRs Merged', 'BitbucketPullRequestMerged', 40, 'No Conflicts Here')
  create_achievement_rule('Eighty Bitbucket PRs Merged', 'BitbucketPullRequestMerged', 80, 'Merge Master')
  create_achievement_rule('Two Hundred Bitbucket PRs Merged', 'BitbucketPullRequestMerged', 200, 'Merge Guru')
  #=======================================

  #============== Jira ==============
  create_points_rule('Jira Issue Created', 'JiraIssueCreated', [{ name: 'Points', count: 5 }, { name: 'Exp', count: 50 }])
  create_points_rule('Jira Issue Updated', 'JiraIssueUpdated', [{ name: 'Points', count: 1 }, { name: 'Exp', count: 10 }])
  create_points_rule('Jira Worklog Created', 'JiraWorklogCreated', [{ name: 'Points', count: 10 }, { name: 'Exp', count: 100 }])
  create_points_rule('Jira Comment Created', 'JiraCommentCreated', [{ name: 'Points', count: 1 }, { name: 'Exp', count: 10 }])

  create_achievement_rule('Log Jira Work Once', 'JiraWorklogCreated', 1, 'Off to Work You Go')
  create_achievement_rule('Log Jira Work Five Times', 'JiraWorklogCreated', 5, 'Workin\' 9 Till 5')
  create_achievement_rule('Log Jira Work Ten Times', 'JiraWorklogCreated', 10, 'On Time')
  create_achievement_rule('Log Jira Work Twenty Times', 'JiraWorklogCreated', 20, 'Works Wonders')
  create_achievement_rule('Log Jira Work Forty Times', 'JiraWorklogCreated', 40, 'Working Bee')
  create_achievement_rule('Log Jira Work Eighty Times', 'JiraWorklogCreated', 80, 'Busy Beaver')
  create_achievement_rule('Log Jira Work Two Hundred Times', 'JiraWorklogCreated', 200, 'Lumberjack')
  #=======================================

  #============== Heroku Deploy Hooks ====
  create_points_rule('Heroku Deploy', 'HerokuDeploy', [{ name: 'Points', count: 25 }, { name: 'Exp', count: 250 }])

  create_achievement_rule('One Heroku Deploy', 'HerokuDeploy', 1, 'First Deployment')
  create_achievement_rule('Five Heroku Deploys', 'HerokuDeploy', 5, 'Officer Cadet')
  create_achievement_rule('Ten Heroku Deploys', 'HerokuDeploy', 10, 'Second Lieutenant')
  create_achievement_rule('Twenty Heroku Deploys', 'HerokuDeploy', 20, 'First Lieutenant')
  create_achievement_rule('Forty Heroku Deploys', 'HerokuDeploy', 40, 'Captain')
  create_achievement_rule('Eighty Heroku Deploys', 'HerokuDeploy', 80, 'Colonel')
  create_achievement_rule('Two Hundred Heroku Deploys', 'HerokuDeploy', 200, 'Major General')
  #=======================================

end
