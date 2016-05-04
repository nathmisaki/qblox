module Qblox
  # Contains all configuration needed to correctly use Quickblox REST API
  class Config
    BASE_API_ENDPOINT = 'https://api.quickblox.com'
    attr_accessor(:account_key, :account_id, :api_endpoint, :chat_endpoint,
                  :turnserver_endpoint, :s3_bucket_name, :application_id,
                  :auth_key, :auth_secret)

    def initialize(account_key: nil)
      @account_key = account_key
    end

    def base_api_endpoint
      BASE_API_ENDPOINT
    end
  end
end
