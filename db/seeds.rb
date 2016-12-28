require 'game_server/admin/request/player_external_event_request'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

web_hook = WebHook.new
web_hook.name = 'Semaphore'
web_hook.source_identifier = 'semaphore'

name_alias = web_hook.web_hook_alias_keys.build
name_alias.alias_key = 'commit.author_name'
name_alias.alias_type = Alias::AliasType::NAME

email_alias = web_hook.web_hook_alias_keys.build
email_alias.alias_key = 'commit.author_email'
email_alias.alias_type = Alias::AliasType::EMAIL

rule = web_hook.web_hook_rules.build
rule.name = 'Post Build Success'

predicate = rule.web_hook_predicates.build
predicate.web_hook_key = 'result'
predicate.expected_value = 'passed'

consequent = rule.web_hook_consequents.build
consequent.event_name = GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT

rule = web_hook.web_hook_rules.build
rule.name = 'Post Build Failed'

predicate = rule.web_hook_predicates.build
predicate.web_hook_key = 'result'
predicate.expected_value = 'failed'

consequent = rule.web_hook_consequents.build
consequent.event_name = GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT

web_hook.save!
