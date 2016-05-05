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
            conn.request :url_encoded
            conn.adapter Faraday.default_adapter # make requests with Net::HTTP
          end
        end

        def url(path: nil, format: nil, id: nil)
          "/#{path || @path}#{"/#{id}" if id}.#{format || @format}"
        end

        def query(method, &req_block)
          response = connection.send(method) do |req|
            req.url url
            req.headers = headers
            req_block.call(req) if req_block
          end
          check_success(response)
          puts response.inspect
          response
        end

        private

        def check_success(response)
          return if response.status >= 200 && response.status < 300
          fail(Error, "Status: #{response.status} Body: #{response.body}\n"\
               "#{response.inspect}")
        end

        def json_parse(body)
          JSON.parse(body)
        end
      end
    end
  end
end
