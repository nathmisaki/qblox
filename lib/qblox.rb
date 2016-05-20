require 'qblox/version'
require 'qblox/config'
require 'qblox/api/helpers/error'
require 'qblox/api/helpers/require_user_session'

require 'qblox/api/connections/base'
require 'qblox/api/connections/api_endpoint'

require 'qblox/api/account_settings'
require 'qblox/api/session'
require 'qblox/api/user'
require 'qblox/api/dialog'
require 'qblox/api/message'
require 'qblox/api/blob'

require 'qblox/base'
require 'qblox/blob'
require 'qblox/dialog'
require 'qblox/message'
require 'qblox/user'

# Module Interface that exposes some of the functionality for the Qbox gem
module Qblox
  def self.config(&block)
    @config ||= Config.new

    if block
      block.call(@config)
    end

    @config
  end
end
