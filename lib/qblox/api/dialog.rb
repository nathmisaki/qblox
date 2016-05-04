module Qblox
  module Api
    class Dialog < ApiEndpoint
      include RequireUserSession
      def initialize(*args)
        super(*args)
        @path = 'chat/Dialog'
      end

      # Get a list of Dialogs that a user participates
      # http://quickblox.com/developers/Chat#Retrieve_dialogs
      #
      # options keyword should be a hash and could contain keys
      # to filter results. Just as explained on the link above
      def index(user: nil, token: nil, options: {})
        token = token || get_token_for(
          password: user[:password],
          email: user[:email],
          login: user[:login])
        response = query(:get) do |req|
          req.url url
          req.headers = headers.merge(QB_TOKEN_HEADER => token)
        end
        json_parse(response.body)
      end
    end
  end
end
