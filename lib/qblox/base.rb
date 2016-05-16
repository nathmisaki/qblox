module Qblox
  class Base
    def initialize(attrs = {})
      self.attributes = attrs
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
