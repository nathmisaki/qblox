module Qblox
  module Api
    # http://quickblox.com/developers/Overview
    class AccountSettings < Base
      def initialize(*args)
        super(*args)
        @path = 'account_settings'
      end

      def headers
        super.merge('QB-Account-Key' => Qblox.config.account_key)
      end

      def fetch
        response = query :get do |req|
          req.url url
          req.headers = headers
        end
        json_parse(response.body)
      end
    end
  end
end
