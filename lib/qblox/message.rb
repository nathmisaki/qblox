module Qblox
  class Message < Base
    ATTRIBUTES = [:_id, :created_at, :updated_at, :attachments, :read_ids,
             :delivered_ids, :chat_dialog_id, :date_sent, :message,
             :recipient_id, :sender_id]
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
      @extension = Struct.new(custom.keys.map(&:to_sym)).new(custom.values)
    end
  end
end
