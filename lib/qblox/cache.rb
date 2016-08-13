require 'singleton'
require 'yaml'
require 'digest/sha1'
require 'redis'

module Qblox
  class Cache
    include Singleton

    def self.hexdigest(obj)
      Digest::SHA1.hexdigest(obj.inspect)
    end

    def initialize
      @url = Qblox.config.cache_url
      @uri = URI.parse(@url)
      port = @uri.port == '' ? 6379 : @uri.port
      @redis = Redis.new(host: @uri.host, port: port)
      @db = @uri.path.gsub(%r{^/}, '').to_i
      @redis.select @db
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
