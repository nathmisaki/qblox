module Qblox
  module Api
    # http://quickblox.com/developers/Overview
    class AccountSettings < Connections::Base
      @path = 'account_settings'

      def headers
        super.merge('QB-Account-Key' => Qblox.config.account_key)
      end

      def fetch
        response = query :get
        json_parse(response.body)
      end
    end
  end
end
