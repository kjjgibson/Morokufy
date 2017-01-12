require 'game_server/admin/request/player_external_event_request'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

WebHook.transaction do
  #============== Semaphore ==============
  web_hook = WebHook.find_or_initialize_by(name: 'Semaphore')
  web_hook.update_attributes!(source_identifier: 'semaphore')

  web_hook.web_hook_alias_keys.destroy_all
  web_hook.web_hook_rules.destroy_all

  web_hook.web_hook_alias_keys.create(alias_key: 'commit.author_name', alias_type: Alias::AliasType::NAME)
  web_hook.web_hook_alias_keys.create(alias_key: 'commit.author_email', alias_type: Alias::AliasType::EMAIL)

  #===== Successful Build Rule
  rule = web_hook.web_hook_rules.create(name: 'Post Build Success')
  JsonPathResultMatchesPredicate.create(web_hook_rule: rule, path: 'result', expected_values: ['passed'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)

  #===== Failed Build Rule
  rule = web_hook.web_hook_rules.create(name: 'Post Build Failed')
  JsonPathResultMatchesPredicate.create(web_hook_rule: rule, path: 'result', expected_values: ['failed'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT)
  #=======================================

  #============== BitBucket ==============
  web_hook = WebHook.find_or_initialize_by(name: 'Bitbucket')
  web_hook.update_attributes!(source_identifier: 'bitbucket')

  web_hook.web_hook_alias_keys.destroy_all
  web_hook.web_hook_rules.destroy_all

  web_hook.web_hook_alias_keys.create(alias_key: 'actor.display_name', alias_type: Alias::AliasType::NAME)
  web_hook.web_hook_alias_keys.create(alias_key: 'actor.username', alias_type: Alias::AliasType::USERNAME)

  #===== Repo Push Rule
  rule = web_hook.web_hook_rules.create(name: 'Repository Push')
  HeaderMatchesPredicate.create(web_hook_rule: rule, header: 'X-Event-Key', expected_values: ['repo:push'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_REPOSITORY_PUSH)

  #===== PR Created Rule
  rule = web_hook.web_hook_rules.create(name: 'PR Created')
  HeaderMatchesPredicate.create(web_hook_rule: rule, header: 'X-Event-Key', expected_values: ['pullrequest:created'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_CREATED)

  #===== PR Updated Rule
  rule = web_hook.web_hook_rules.create(name: 'PR Updated')
  HeaderMatchesPredicate.create(web_hook_rule: rule, header: 'X-Event-Key', expected_values: ['pullrequest:updated'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_UPDATED)

  #===== PR Approved Rule
  rule = web_hook.web_hook_rules.create(name: 'PR Approved')
  HeaderMatchesPredicate.create(web_hook_rule: rule, header: 'X-Event-Key', expected_values: ['pullrequest:approved'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_APPROVED)

  #===== PR Merged Rule
  rule = web_hook.web_hook_rules.create(name: 'PR Merged')
  HeaderMatchesPredicate.create(web_hook_rule: rule, header: 'X-Event-Key', expected_values: ['pullrequest:fulfilled'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_MERGED)

  #===== PR Comment Created Rule
  rule = web_hook.web_hook_rules.create(name: 'PR Comment Created')
  HeaderMatchesPredicate.create(web_hook_rule: rule, header: 'X-Event-Key', expected_values: ['pullrequest:comment_created'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_COMMENT_CREATED)
  #=======================================

  #============== JIRA ==============
  web_hook = WebHook.find_or_initialize_by(name: 'Jira')
  web_hook.update_attributes!(source_identifier: 'jira')

  web_hook.web_hook_alias_keys.destroy_all
  web_hook.web_hook_rules.destroy_all

  web_hook.web_hook_alias_keys.create(alias_key: 'user.name', alias_type: Alias::AliasType::NAME)
  web_hook.web_hook_alias_keys.create(alias_key: 'user.emailAddress', alias_type: Alias::AliasType::EMAIL)
  web_hook.web_hook_alias_keys.create(alias_key: 'user.displayName', alias_type: Alias::AliasType::DISPLAY_NAME)

  #===== Issue Created Rule
  rule = web_hook.web_hook_rules.create(name: 'Issue Created')
  JsonPathResultMatchesPredicate.create(web_hook_rule: rule, path: 'webhookEvent', expected_values: ['jira:issue_created'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::JIRA_ISSUE_CREATED)

  #===== Issue Updated Rule
  #TODO: different events based on what exactly is updated
  rule = web_hook.web_hook_rules.create(name: 'Issue Updated')
  JsonPathResultMatchesPredicate.create(web_hook_rule: rule, path: 'webhookEvent', expected_values: ['jira:issue_updated'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::JIRA_ISSUE_UPDATED)

  #===== Worklog Created Rule
  rule = web_hook.web_hook_rules.create(name: 'Worklog Updated')
  JsonPathResultMatchesPredicate.create(web_hook_rule: rule, path: 'webhookEvent', expected_values: ['worklog_created'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::JIRA_WORKLOG_CREATED)

  #===== Issue Comment Created Rule
  rule = web_hook.web_hook_rules.create(name: 'Issue Comment Created')
  JsonPathResultMatchesPredicate.create(web_hook_rule: rule, path: 'issue_event_type_name', expected_values: ['issue_commented'])
  rule.web_hook_consequents.create(event_name: GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::JIRA_COMMENT_CREATED)
  #=======================================
end