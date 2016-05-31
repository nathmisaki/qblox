module Qblox
  class Message < Base
    ATTRIBUTES = [:_id, :created_at, :updated_at, :attachments, :read_ids,
                  :delivered_ids, :chat_dialog_id, :date_sent, :message,
                  :recipient_id, :sender_id, :read]
    attr_accessor *ATTRIBUTES
    attr_reader :custom, :extension
    alias :id :_id

    def initialize(attrs = {})
      @custom = {}
      super(attrs)
    end

    def attributes=(attrs)
      ats = Set.new(ATTRIBUTES.map(&:to_s))
      attrs.each do |k,v|
        if ats.include?(k.to_s)
          send("#{k}=", v)
        else
          @custom[k] = v
        end
      end
      @extension = Struct.new(*custom.keys.map(&:to_sym)).new(*custom.values)
    end

    class Collection < Array
      attr_accessor(:total_entries, :skip, :limit, :items)

      def initialize(attrs)
        self.total_entries = attrs['total_entries']
        self.skip = attrs['skip']
        self.limit = attrs['limit']
        self.items = attrs['items']
        items.each do |item|
          push(Qblox::Message.new(item))
        end
      end
    end
  end
end
