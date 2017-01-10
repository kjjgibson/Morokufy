def build_external_event(name, description)
  e = ExternalEvent.find_or_initialize_by(name: name)
  e.description = description
  e.save!
end

ExternalEvent.transaction do
  build_external_event('SemaphoreBuildPassed', 'A successful Semaphore build')
  build_external_event('SemaphoreBuildFailed', 'A failed Semaphore build')
  build_external_event('BitbucketRepositoryPush', 'A push to a repository')
  build_external_event('BitbucketPullRequestCreated', 'Pull Request created')
  build_external_event('BitbucketPullRequestUpdated', 'Pull Request updated')
  build_external_event('BitbucketPullRequestApproved', 'Pull Request approved')
  build_external_event('BitbucketPullRequestMerged', 'Pull Created merged')
  build_external_event('BitbucketPullRequestCommentCreated', 'Pull Request comment created')
  build_external_event('JiraIssueCreated', 'Jira issue created')
  build_external_event('JiraIssueUpdated', 'Jira issue updated')
  build_external_event('JiraWorklogCreated', 'Jira worklog created')
  build_external_event('JiraCommentCreated', 'Jira comment created')
  build_external_event('JiraBoardCreated', 'Jira board created')
  build_external_event('JiraBoardUpdated', 'Jira board updated')
  build_external_event('JiraSprintCreated', 'Jira sprint created')
  build_external_event('JiraSprintUpdated', 'Jira sprint updated')
  build_external_event('JiraSprintStarted', 'Jira sprint started')
  build_external_event('JiraSprintClosed', 'Jira sprint closed')
end