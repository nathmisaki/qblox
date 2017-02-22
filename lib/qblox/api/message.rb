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
          req.headers = headers.merge('Content-Type' => 'application/json')
          req.body = JSON.dump(@params)
        end
        json_parse(response.body)
      end

      def index(chat_dialog_id, options = {})
        result = options.delete(:result)
        all = options.key?(:all) ? options.delete(:all) : true
        count = options.delete(:count)
        skip = options.delete(:skip) || 0

        response = query(:get, params: {chat_dialog_id: chat_dialog_id, limit: 100, skip: skip })
        data = json_parse(response.body)
        return data unless all

        count ||= count_messages(chat_dialog_id)

        if result
          result['items'].concat(data['items'])
        else
          result ||= data
        end

        if count > result['items'].size
          result = index(chat_dialog_id,
                         options.merge(skip: result['items'].size,
                                       result: result,
                                       count: count))
        end
        return result
      end

      def update(message_id, options = {})
        response = query(:put) do |req|
          req.url url(id: message_id)
          req.params = options
        end
        response
      end

      def update_all(options = {})
        response = query(:put) do |req|
          req.params = options
        end
        response
      end

      def destroy(message_id, options = {})
        response = query(:delete) do |req|
          req.url url(id: message_id)
          req.params = options
        end
        return true
      end

      def count_messages(chat_dialog_id)
        response = query(:get, params: {chat_dialog_id: chat_dialog_id, count: 1})
        count = json_parse(response.body)
        count['items']['count'].to_i
      end

      def unread(chat_dialog_ids=[])
        response = query(:get) do |req|
          req.url url(custom_action: '/unread'), { chat_dialog_ids: chat_dialog_ids.to_a.join(',') }
        end
        json_parse(response.body)
      end

      private

      def validate_params(data)
        if data[:chat_dialog_id].nil? && data[:recipient_id].nil?
          fail(ArgumentError, 'You need to provide chat_dialog_id or '\
               'recipient_id')
        end
        data
      end
    end
  end
end