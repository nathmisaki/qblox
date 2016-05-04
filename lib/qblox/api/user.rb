module Qblox
  module Api
    # Manage Users on Quickblox
    class User < ApiEndpoint
      ATTRIBUTES = %w(login password email blob_id external_user_id
                   facebook_id twitter_id full_name phone website
                   custom_data tag_list).map(&:to_sym)
      def initialize(*args)
        super(*args)
        @path = 'users'
      end

      # User Sign Up API
      # http://quickblox.com/developers/Users#API_User_Sign_Up
      def create(args = {})
        token = args.delete(:token) || get_api_token
        response = query(:post) do |req|
          req.url url
          req.headers = headers.merge("#{QB_TOKEN_HEADER}" => token)
          req.params['user'] = params(args)
        end
      end

      private

      def get_api_token
        @session ||= Qblox::Api::Session.new.create
        @session['session']['token']
      end

      def params(args = {})
        if args[:password].nil?
          fail ArgumentError, 'You need to provide password'
        end
        if args[:login].nil? && args[:email].nil?
          fail ArgumentError, 'You need to provide either login or email'
        end
        ATTRIBUTES.each_with_object({}) do |attr, hash|
          hash[attr] = args[attr] if args[attr]
        end
      end
    end
  end
end
