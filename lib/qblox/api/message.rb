module Qblox
  module Api
    # Message API
    # http://quickblox.com/developers/Chat#Retrieve_messages
    class Message < Connections::ApiEndpoint
      include RequireUserSession
      @path = 'chat/Message'

      def create(data = {})
        response = query(:post) do |req|
          req.params = params(data)
        end
        json_parse(response.body)
      end

      def index(chat_dialog_id, options = {})
        response = query(:get) do |req|
          req.params = options.merge(chat_dialog_id: chat_dialog_id)
        end
        json_parse(response.body)
      end

      private

      def params(data)
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
