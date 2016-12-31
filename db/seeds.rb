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
  web_hook.source_identifier = 'semaphore'

  web_hook.web_hook_alias_keys.destroy_all
  name_alias = web_hook.web_hook_alias_keys.build
  name_alias.alias_key = 'commit.author_name'
  name_alias.alias_type = Alias::AliasType::NAME

  email_alias = web_hook.web_hook_alias_keys.build
  email_alias.alias_key = 'commit.author_email'
  email_alias.alias_type = Alias::AliasType::EMAIL

  web_hook.web_hook_rules.destroy_all
  #===== Successful Build Rule
  rule = web_hook.web_hook_rules.build
  rule.name = 'Post Build Success'

  rule.web_hook_predicates.destroy_all
  predicate = ValueMatchesPredicate.new(web_hook_rule: rule, key_path: 'result', expected_value: 'passed')
  rule.web_hook_predicates << predicate

  rule.web_hook_consequents.destroy_all
  consequent = rule.web_hook_consequents.build
  consequent.event_name = GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT

  #===== Failed Build Rule
  rule = web_hook.web_hook_rules.build
  rule.name = 'Post Build Failed'

  rule.web_hook_predicates.destroy_all
  predicate = ValueMatchesPredicate.new(web_hook_rule: rule, key_path: 'result', expected_value: 'failed')
  rule.web_hook_predicates << predicate

  rule.web_hook_consequents.destroy_all
  consequent = rule.web_hook_consequents.build
  consequent.event_name = GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT

  web_hook.save!
  #=======================================

  #============== BitBucket ==============
  web_hook = WebHook.find_or_initialize_by(name: 'Bitbucket')
  web_hook.source_identifier = 'bitbucket'

  web_hook.web_hook_alias_keys.destroy_all
  name_alias = web_hook.web_hook_alias_keys.build
  name_alias.alias_key = 'actor.display_name'
  name_alias.alias_type = Alias::AliasType::NAME

  username_alias = web_hook.web_hook_alias_keys.build
  username_alias.alias_key = 'actor.username'
  username_alias.alias_type = Alias::AliasType::USERNAME

  web_hook.web_hook_rules.destroy_all
  #===== Repo Push Rule
  rule = web_hook.web_hook_rules.build
  rule.name = 'Repository Push'

  rule.web_hook_predicates.destroy_all
  predicate = HeaderMatchesPredicate.new(web_hook_rule: rule, header: 'X-Event-Key', expected_value: 'repo:push')
  rule.web_hook_predicates << predicate

  rule.web_hook_consequents.destroy_all
  consequent = rule.web_hook_consequents.build
  consequent.event_name = GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_REPOSITORY_PUSH

  #===== PR Created Rule
  #TODO:

  web_hook.save!
  #=======================================

end