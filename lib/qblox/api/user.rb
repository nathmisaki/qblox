module Qblox
  module Api
    # Manage Users on Quickblox
    class User < Connections::ApiEndpoint
      @path = 'users'
      ATTRIBUTES = %w(login password email blob_id external_user_id
                      facebook_id twitter_id full_name phone website
                      custom_data tag_list).map(&:to_sym)

      def headers
        token = @token || api_token
        super.merge(QB_TOKEN_HEADER => token)
      end

      # User Sign Up API
      # http://quickblox.com/developers/Users#API_User_Sign_Up
      def create(args = {})
        @token = args.delete(:token)
        response = query(:post) do |req|
          req.params['user'] = params(args)
        end
        json_parse(response.body)
      end

      # Show API User by Identifier
      # http://quickblox.com/developers/Users#Show_API_User_by_identifier
      def find_by_id(id)
        response = query(:get) do |req|
          req.url url(id: id)
        end
        json_parse(response.body)
      end

      # Show API User by External User Id
      # http://quickblox.com/developers/Users#Retrieve_API_User_by_external_user_id
      def find_by_external_id(id)
        response = query(:get) do |req|
          req.url url(id: id, path: 'users/external')
        end
        json_parse(response.body)
      end

      private

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
