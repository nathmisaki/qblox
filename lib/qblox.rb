require 'qblox/version'
require 'qblox/config'
require 'qblox/api/base'
require 'qblox/api/account_settings'

# Module Interface that exposes some of the functionality for the Qbox gem
module Qblox
  def self.config(&block)
    if block
      @config ||= Config.new
      block.call(@config)
    end
    @config
  end

  def self.fetch_account_settings
    Qblox::Api::AccountSettings.new.get.each do |key, val|
      config.send("#{key}=", val)
    end
  end
end
