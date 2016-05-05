module Qblox
  class Dialog
    attr_accessor(:id, :owner_id, :full_name, :email, :login, :phone,
                :website, :created_at, :updated_at, :last_request_at,
                :external_user_id, :facebook_id, :twitter_id, :blob_id,
                :custom_data, :twitter_digits_id, :user_tags)


    private

    def attributes=(attrs)
      attrs = attrs['user'] if attrs['user']
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
