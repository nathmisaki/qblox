module Qblox
  class Message < Base
    ATTRIBUTES = [:_id, :created_at, :updated_at, :attachments, :read_ids,
                  :delivered_ids, :chat_dialog_id, :date_sent, :message,
                  :recipient_id, :sender_id, :read, :token]
    attr_accessor *ATTRIBUTES
    attr_reader :custom, :extension

    def initialize(attrs = {})
      @custom = {}
      super(attrs)
    end

    def attributes=(attrs)
      ats = Set.new(ATTRIBUTES.map(&:to_s))
      attrs.each do |k,v|
        begin
          send("#{k}=", v)
        rescue NoMethodError
          @custom[k] = v
        end
      end
      if custom.keys.size > 0
        @extension = Struct.new(*custom.keys.map(&:to_sym)).new(*custom.values)
      end
    end

    def destroy(token: nil, force: false)
      Qblox::Api::Message.new(token: token || @token).destroy(id, force: force ? '1' : '0')
    end

    class Collection < Array
      attr_accessor(:total_entries, :skip, :limit, :items)

      def initialize(attrs, token: nil)
        self.total_entries = attrs['total_entries']
        self.skip = attrs['skip']
        self.limit = attrs['limit']
        self.items = attrs['items']
        items.each do |item|
          push(Qblox::Message.new(item.merge(token: token)))
        end
      end
    end
  end
end
