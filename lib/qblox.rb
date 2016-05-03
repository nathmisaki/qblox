require 'qblox/version'
require 'qblox/config'

# Module Interface that exposes some of the functionality for the Qbox gem
module Qblox
  def self.config(&block)
    if block
      @config ||= Config.new
      block.call(@config)
    end
    @config
  end
end
