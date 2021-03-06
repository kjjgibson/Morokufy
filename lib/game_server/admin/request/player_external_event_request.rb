require 'game_server/admin/request/admin_request'
require 'game_server/admin/response/external_event_response'
require 'game_server/model/rule_result_points_award'
require 'game_server/model/rule_result_achievement_award'

module GameServer
  module Admin
    module Request
      class PlayerExternalEventRequest < GameServer::Admin::Request::AdminRequest

        PATH = '/player_external_events'

        module EventTypes
          SEMAPHORE_BUILD_FAILED_EVENT = 'SemaphoreBuildFailed'
          SEMAPHORE_BUILD_PASSED_EVENT = 'SemaphoreBuildPassed'
          BITBUCKET_REPOSITORY_PUSH = 'BitbucketRepositoryPush'
          BITBUCKET_PULL_REQUEST_CREATED = 'BitbucketPullRequestCreated'
          BITBUCKET_PULL_REQUEST_UPDATED = 'BitbucketPullRequestUpdated'
          BITBUCKET_PULL_REQUEST_APPROVED = 'BitbucketPullRequestApproved'
          BITBUCKET_PULL_REQUEST_MERGED = 'BitbucketPullRequestMerged'
          BITBUCKET_PULL_REQUEST_COMMENT_CREATED = 'BitbucketPullRequestCommentCreated'
          JIRA_ISSUE_CREATED = 'JiraIssueCreated'
          JIRA_ISSUE_UPDATED = 'JiraIssueUpdated'
          JIRA_WORKLOG_CREATED = 'JiraWorklogCreated'
          JIRA_COMMENT_CREATED = 'JiraCommentCreated'
          JIRA_BOARD_CREATED = 'JiraBoardCreated'
          JIRA_BOARD_UPDATED = 'JiraBoardUpdated'
          JIRA_SPRINT_CREATED = 'JiraSprintCreated'
          JIRA_SPRINT_UPDATED = 'JiraSprintUpdated'
          JIRA_SPRINT_STARTED = 'JiraSprintStarted'
          JIRA_SPRINT_CLOSED = 'JiraSprintClosed'
          HEROKU_DEPLOY = 'HerokuDeploy'
        end

        def log_event(player_ext_id, external_event_name)
          body = { player: player_ext_id, external_event_id: external_event_name }
          response = post(PATH, body)

          response_body = JSON.parse(response.body, symbolize_names: true)

          if response.success?
            points_awards = points_awards(response_body[:points_awarded])
            achievement_awards = achievement_awards(response_body[:achievements_awarded])

            external_event_response = GameServer::Admin::Response::ExternalEventResponse.new(true, nil, points_awards, achievement_awards)
          else
            error_message = response_body[:error_message]

            external_event_response = GameServer::Admin::Response::ExternalEventResponse.new(false, error_message, nil, nil)
          end

          return external_event_response
        end

        # Create an array of PointsAward objects from the points_awarded response Hash
        #
        # === Parameters
        #
        # * +points_awarded_hash+ - Hash in the form: { <point_type>: <number_of_points> }
        private def points_awards(points_awarded_hash)
          points_awards_array = []
          (points_awarded_hash || []).each do |key, value|
            points_awards_array << GameServer::Model::RuleResultPointsAward.new(key.to_s, value)
          end
          return points_awards_array
        end

        # Create an array of AchievementAward objects from the achievements_awarded response Hash
        #
        # === Parameters
        #
        # * +achievements_awarded_hash+ - Array in the form: [{ achievement_id: <id>, created_at: <datetime> }, ...]
        private def achievement_awards(achievements_awarded_hash)
          achievement_awards_array = []
          (achievements_awarded_hash || []).each do |achievement_award|
            achievement_awards_array << GameServer::Model::RuleResultAchievementAward.new(achievement_award[:achievement_id])
          end
          return achievement_awards_array
        end

      end
    end
  end
end