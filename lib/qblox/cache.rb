require 'singleton'
module Qblox
  # Cache needs a {Config#cache_store}
  #
  class Cache
    include Singleton

    def initialize
      @cache_store = Qblox.config.cache_store
      if @cache_store
        @caching = Qblox.config.caching.nil? ? true : Qblox.config.caching
      else
        @caching = false
      end
    end

    def fetch(key, seconds_expiration, &block)
      return block.call unless @caching

      content = @cache_store.get(key)
      return content if content

      content = block.call

      @cache_store.set_with_expiration(key, seconds_expiration, content)

      content
    end
  end
end
