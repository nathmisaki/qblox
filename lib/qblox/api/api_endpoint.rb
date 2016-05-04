module Qblox
  module Api
    # Base class to use a new connection of ApiEndpoint
    class ApiEndpoint < Base
      QB_TOKEN_HEADER = 'QB-Token'

      def connection
        Faraday.new(url: @config.api_endpoint) do |conn|
          conn.request :url_encoded
          conn.adapter Faraday.default_adapter # make requests with Net::HTTP
        end
      end
    end
  end
end
