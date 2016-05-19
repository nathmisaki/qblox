module Qblox
  module Api
    # Message API
    # http://quickblox.com/developers/Chat#Retrieve_messages
    class Message < Connections::ApiEndpoint
      include RequireUserSession
      @path = 'chat/Message'

      def create(data = {})
        @params = data
        validate_params(@params)
        response = query(:post) do |req|
          req.params = @params
        end
        json_parse(response.body)
      end

      def index(chat_dialog_id, options = {})
        @params = options
        response = query(:get) do |req|
          req.headers = headers.merge('Content-Type' => 'application/json')
          req.body = JSON.dump(options)
          req.params = { chat_dialog_id: chat_dialog_id }
        end
        json_parse(response.body)
      end

      def update(message_id, options = {})
        response = query(:put) do |req|
          req.url url(id: message_id)
          req.params = options
        end
        json_parse(response.body)
      end

      def destroy(message_id, options = {})
        response = query(:delete) do |req|
          req.url url(id: message_id)
          req.params = options
        end
        puts response.inspect
        return true
      end

      private

      def validate_params(data)
        if data[:chat_dialog_id].nil? && data[:recipient_id].nil?
          fail(ArgumentError, 'You need to provide chat_dialog_id or '\
               'recipient_id')
        end

        fail ArgumentError, 'message required' if data[:message].nil?
        data
      end
    end
  end
end
