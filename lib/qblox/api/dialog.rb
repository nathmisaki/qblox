module Qblox
  module Api

    class Dialog < Connections::ApiEndpoint
      @path = 'chat/Dialog'
      include RequireUserSession

      # Get a list of Dialogs that a user participates
      # http://quickblox.com/developers/Chat#Retrieve_dialogs
      #
      # options keyword should be a hash and could contain keys
      # to filter results. Just as explained on the link above
      def index(options = {})
        result = options.delete(:result)
        all = options.delete('all') || true
        response = query(:get) do |req|
          req.params = options
        end
        data = json_parse(response.body)
        return data unless all

        if result
          result['items'].concat(data['items'])
        else
          result ||= data
        end

        if result['total_entries'] > result['items'].size
          result = index(options.merge(skip: result['items'].size,
                                     result: result))
        end
        return result
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
          req.params = data
        end
        data = json_parse(response.body)
      end

      def update(chat_dialog_id, data = {})
        response = query(:put) do |req|
          req.url url(id: chat_dialog_id)
          req.params = data
        end
        json_parse(response.body)
      end

      def delete(chat_dialog_id, data = {})
        response = query(:delete) do |req|
          req.url url(id: chat_dialog_id)
          req.params = data
        end
        json_parse(response.body)
      end
    end
  end
end
