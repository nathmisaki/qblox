require 'qblox/version'
require 'qblox/config'
require 'qblox/api/error'
require 'qblox/api/base'
require 'qblox/api/api_endpoint'
require 'qblox/api/account_settings'
require 'qblox/api/session'
require 'qblox/api/user'
require 'qblox/api/require_user_session'
require 'qblox/api/dialog'

# Module Interface that exposes some of the functionality for the Qbox gem
module Qblox
  def self.config(&block)
    @config ||= Config.new

    if block
      block.call(@config)
      fetch_account_settings if @config.api_endpoint.nil?
    end

    @config
  end

  def self.fetch_account_settings
    Qblox::Api::AccountSettings.new.fetch.each do |key, val|
      config.send("#{key}=", val)
    end
  end
end
