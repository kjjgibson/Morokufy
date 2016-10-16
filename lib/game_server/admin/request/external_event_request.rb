require 'game_server/admin/request/admin_request'
require 'game_server/admin/response/external_event_response'
require 'game_server/model/points_award'
require 'game_server/model/achievement_award'

module GameServer
  module Admin
    module Request
      class ExternalEventRequest < GameServer::Admin::Request::AdminRequest

        PATH = '/external_events'

        module EventTypes
          SEMAPHORE_BUILD_FAILED_EVENT = 'SemaphoreBuildFailed'
          SEMAPHORE_BUILD_PASSED_EVENT = 'SemaphoreBuildPassed'
        end

        def log_event(player_ext_id, external_event_name)
          body = { player_ext_id: player_ext_id, external_event_id: external_event_name }
          response = post("#{PATH}/log_event", body, headers: { 'API-VERSION': 'v2' })
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
            points_awards_array << GameServer::Model::PointsAward.new(key, value)
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
            achievement_awards_array << GameServer::Model::AchievementAward.new(achievement_award[:achievement_id])
          end
          return achievement_awards_array
        end

      end
    end
  end
end