require 'securerandom'

module Qblox
  module Api
    # Manage Session on Quickblox
    # http://quickblox.com/developers/Authentication_and_Authorization
    class Session < ApiEndpoint
      def initialize(opts={})
        super(opts)
        @path = 'session'
      end

      # Create a Session (both API Session or API User Sign In)
      #
      # To create an API Session, need no arguments.
      # To create an API User Sign In, need at least user argument
      # with login/email and password.
      # E.g.: create(user: { email: 'example@example.com', password: '***' })
      #
      # provider, keys, twitter_digits should be used just like the
      # documentation http://quickblox.com/developers/Authentication_and_Authorization#API_Session_Creation
      def create(*args)
        response = query :post do |req|
          req.url url
          req.headers = headers
          req.params = params(*args)
        end
        data = json_parse(response.body)
        data['session']['token_expiration'] =
          Time.parse(response.headers['qb-token-expirationdate'])
        data
      end

      private

      def params(user: nil, provider: nil, keys: nil, twitter_digits: nil)
        data = { application_id: @config.application_id,
                 auth_key: @config.auth_key,
                 timestamp: Time.now.to_i,
                 nonce: SecureRandom.random_number(100_000) }

        data.merge!(user: user) if user
        data.merge!(provider: provider) if provider
        data.merge!(keys: keys) if keys
        data.merge!(keys: twitter_digits) if twitter_digits
        data[:signature] = sign(data)
        data
      end

      def norm_hash(hash, parent: nil)
        norms = []
        hash.to_a.sort { |a, b| a.first <=> b.first }
          .each do |key, val|
          key = "#{parent}[#{key}]" if parent
          norms.push(norm_hash(val, parent: key)) && next if val.is_a?(Hash)
          norms.push("#{key}=#{val}")
        end
        norms.flatten
      end

      def sign(data)
        normalized_string = norm_hash(data).join('&')
        puts normalized_string

        sha1 = OpenSSL::Digest::SHA1.new
        OpenSSL::HMAC.hexdigest(sha1, @config.auth_secret, normalized_string)
      end
    end
  end
end
