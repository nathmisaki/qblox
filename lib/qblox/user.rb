module Qblox
  class User
    attr_accessor(:id, :owner_id, :full_name, :email, :login, :phone,
                  :website, :created_at, :updated_at, :last_request_at,
                  :external_user_id, :facebook_id, :twitter_id, :blob_id,
                  :custom_data, :twitter_digits_id, :user_tags)
    attr_accessor :password

    def self.find(id)
      attrs = Qblox::Api::User.new.find_by_id(id)
      self.new.attributes(attrs['user'])
    end

    def self.find_by_external_id(id)
      attrs = Qblox::Api::User.new.find_by_external_id(id)
      self.new.attributes(attrs['user'])
    end

    def token
      return @token if token_valid?
      @session = Qblox::Api::Session.new.create(session_data)
      @token_expiration = @session['session']['token_expiration']
      @token = @session['session']['token']
    end

    def dialogs
      @dialogs ||= Qblox::Api::Dialog.new(token: token).index
    end

    def messages
    end

    def send_message
    end

    private

    def session_data
      data = { password: password }
      data[:email] = email if email
      data[:login] = login if login
      data
    end

    def token_valid?
      @token && @token_expiration && @token_expiration.to_i > Time.now.to_i
    end
  end
end
