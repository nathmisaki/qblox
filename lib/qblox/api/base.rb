require 'faraday'
require 'json'

module Qblox
  module Api
    # Class responsible for common configs on Api files
    class Base
      def initialize(config: nil)
        @config = config || Qblox.config
        @path = ''
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

      def url(path: nil, format: nil)
        "/#{path || @path}.#{format || @format}"
      end

      def query(method, &req_block)
        response = connection.send(method, &req_block)
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
