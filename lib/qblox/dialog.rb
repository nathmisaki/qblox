module Qblox
  class Dialog < Qblox::Base
    ATTRIBUTES = [:_id, :accessible_for_ids, :created_at, :last_message,
                  :last_message_date_sent, :last_message_user_id, :name,
                  :occupants_ids, :photo, :type, :updated_at, :user_id,
                  :xmpp_room_jid, :unread_messages_count]

    attr_accessor(*ATTRIBUTES)

    def messages(token: nil, options: {})
      return @messages unless @messages.nil? || options != {}
      messages = Qblox::Api::Message.new(token: token || @token).index(id, options)
      messages = Qblox::Message::Collection.new(messages, token: token || @token)
      @messages = messages unless options != {}
      messages
    end

    def attributes
      ATTRIBUTES.each_with_object({}) do |key, hash|
        hash[key] = send(key)
      end
    end

    class Collection < Array
      attr_accessor(:total_entries, :skip, :limit, :items)

      def initialize(attrs, token: nil)
        self.total_entries = attrs['total_entries']
        self.skip = attrs['skip']
        self.limit = attrs['limit']
        self.items = attrs['items']
        items.each do |item|
          push(Qblox::Dialog.new(item.merge(token: token)))
        end
      end
    end
  end
end
