module Qblox
  module Api
    class Error < StandardError
      attr_reader :status_code
      attr_reader :header
      attr_reader :body

      def initialize(status_code: nil, header: nil, body: nil)
        @status_code = status_code
        @header = header.dup unless header.nil?
        @body = body
      end
    end

    class ClientError < Error
    end

    class ServerError < Error
    end

  end
end
