require 'faraday'
require 'json'

module Qblox
  module Api
    module Connections
      # Class responsible for common configs on Api files
      class Base
        def initialize(opts = {})
          @config = opts[:config] || Qblox.config
          @path ||= self.class.instance_variable_get('@path')
          @format = 'json'
          @headers = {
            'QuickBlox-REST-API-Version' => '0.1.1'
          }
        end

        attr_reader :headers

        def connection
          Faraday.new(url: @config.base_api_endpoint) do |conn|
            conn.response :logger
            conn.request :url_encoded
            conn.adapter Faraday.default_adapter # make requests with Net::HTTP
          end
        end

        def url(path: nil, format: nil, id: nil, custom_action: nil)
          aux = ["/"]
          aux.push(path || @path)
          aux.push("/#{id}") if id
          aux.push(custom_action) if custom_action
          aux.push(".#{format || @format}")
          aux.join
        end

        def query(method, params: {},  &req_block)
          response = connection.send(method) do |req|
            req.url url, params
            req.headers = headers
            req_block.call(req) if req_block
          end
          check_success(response)
          response
        end

        private

        def check_success(response)
          return if response.status >= 200 && response.status < 400
          if response.status > 500
            error = ServerError.new(status_code: response.status, headers: response.headers, body: response.body)
          else
            error = ClientError.new(status_code: response.status, headers: response.headers, body: response.body)
          end
          fail(error, "Status: #{response.status} Body: #{response.body}\n"\
               "#{response.inspect}")
        end

        def json_parse(body)
          JSON.parse(body)
        end
      end
    end
  end
end
