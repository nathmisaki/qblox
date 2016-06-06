module Qblox
  class Base
    attr_accessor :token

    def initialize(attrs = {})
      self.attributes = attrs
    end

    def id=(val)
      @_id = val
    end

    def id
      @_id
    end

    def self.instance_all(arr)
      arr.map { |ar| self.new(ar) }
    end

    def attributes=(attrs)
      attrs.each do |key, val|
        begin
          send("#{key}=", val)
        rescue NoMethodError
          # TODO: Log error
        end
      end
      self
    end
  end
end
