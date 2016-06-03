module Qblox
  module Api
    class Error < StandardError
      attr_reader :status_code
      attr_reader :headers
      attr_reader :body

      def initialize(status_code: nil, headers: nil, body: nil)
        @status_code = status_code
        @headers = headers.dup unless headers.nil?
        @body = body
      end
    end

    class ClientError < Error
    end

    class ServerError < Error
    end

  end
end
