module Qblox
  # Contains all configuration needed to correctly use Quickblox REST API
  class Config
    BASE_API_ENDPOINT = 'https://api.quickblox.com'
    attr_accessor(:account_key, :account_id, :application_id,
                  :auth_key, :auth_secret)
    ACCOUNT_SETTINGS_VARS = [:api_endpoint, :chat_endpoint,
                             :turnserver_endpoint, :s3_bucket_name]
    attr_writer *ACCOUNT_SETTINGS_VARS

    def initialize(account_key: nil)
      @account_key = account_key
    end

    def base_api_endpoint
      BASE_API_ENDPOINT
    end

    def fetch_account_settings
      Qblox::Api::AccountSettings.new.fetch.each do |key, val|
        send("#{key}=", val)
      end
    end

    ACCOUNT_SETTINGS_VARS.each do |var|
      define_method var do
        v = instance_variable_get("@#{var}")
        fetch_account_settings if v.nil?
        instance_variable_get("@#{var}")
      end
    end
  end
end
