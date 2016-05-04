module Qblox
  module Api
    class Dialog < ApiEndpoint
      include RequireUserSession
      # This API needs to deal with a user session.
      #
      # So you should pass token, user: { login: '...', password: '***' },
      # or user: { email: '...', password: '***' } to authenticate
      def initialize(opts={})
        super(opts)
        @path = 'chat/Dialog'
        @token = get_token_from_opts(opts)
      end

      def headers
        super.merge(QB_TOKEN_HEADER => @token)
      end

      # Get a list of Dialogs that a user participates
      # http://quickblox.com/developers/Chat#Retrieve_dialogs
      #
      # options keyword should be a hash and could contain keys
      # to filter results. Just as explained on the link above
      def index(options: {})
        response = query(:get) do |req|
          req.url url
          req.headers = headers
        end
        json_parse(response.body)
      end

      def create(data = {})
        fail ArgumentError, 'type is required' if data[:type].nil?
        if data[:type] != 1 && data[:occupants_ids].to_a.size == 0
          fail(ArgumentError, 'occupant_ids should have at least one id '\
               "for type = #{data[:type]}")
        end
        if data[:type] != 3 && data[:name].nil?
          fail(ArgumentError, 'name should be provided for '\
               "type = #{data[:type]}")
        end

        response = query(:post) do |req|
          req.url url
          req.headers = headers
          req.params = data
        end
        json_parse(response.body)
      end
    end
  end
end
