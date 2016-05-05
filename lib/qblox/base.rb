module Qblox
  class Base
    def initialize(attrs = {})
      self.attributes = attrs
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
