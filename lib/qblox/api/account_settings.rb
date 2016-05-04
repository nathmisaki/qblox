module Qblox
  module Api
    # http://quickblox.com/developers/Overview
    class AccountSettings < Base
      def initialize
        super
        @path = 'account_settings'
      end

      def headers
        super.merge('QB-Account-Key' => Qblox.config.account_key)
      end

      def get
        response = connection.get do |req|
          req.url url
          req.headers = headers
        end
        check_success(response)
        json_parse(response.body)
      end
    end
  end
end
