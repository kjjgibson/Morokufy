require 'game_server/admin/request/admin_request'
require 'game_server/admin/response/external_event_response'

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
          response = post("#{PATH}/log_event", body)
          response_body = JSON.parse(response.body, symbolize_names: true)

          if response.is_success?
            #TODO: get points awarded form response

            external_event_response = GameServer::Admin::Response::ExternalEventResponse.new(true, nil)
          else
            error_message = response_body[:error_message]

            external_event_response = GameServer::Admin::Response::ExternalEventResponse.new(false, error_message)
          end

          return external_event_response
        end

      end
    end
  end
end