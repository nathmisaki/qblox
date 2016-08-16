require 'singleton'
module Qblox
  # Cache needs a {Config#cache_store}
  #
  class Cache
    include Singleton

    def initialize
      @cache_store = Qblox.config.cache_store
    end

    def fetch(key, seconds_expiration, &block)
      return block.call unless caching?

      content = @cache_store.get(key)
      return content if content

      content = block.call

      @cache_store.set_with_expiration(key, seconds_expiration, content)

      content
    end

    private

    def caching?
      return false if @cache_store.nil?
      !!Qblox.config.caching
    end
  end
end
