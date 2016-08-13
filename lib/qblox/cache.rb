module Qblox
  class Cache
    include Singleton
    def initialize
      @redis = Redis.new Qblox.config.cache_url
    end

    def fetch(key, seconds_expiration, &block)
      content = @redis.get(key_namespaced(key))
      return decoded_content(content) if content
      content = block.call
      @redis.setex(key_namespaced(key), seconds_expiration,
                   encoded_content(content))
      content
    end

    def encoded_content(content)
      YAML.dump(content)
    end

    def decoded_content(raw_content)
      YAML.load(raw_content)
    end

    def key_namespaced(key)
      "qblox:cache:#{key}"
    end
  end
end
