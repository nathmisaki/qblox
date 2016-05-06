module Qblox
  class User < Base
    attr_accessor(:id, :owner_id, :full_name, :email, :login, :phone,
                  :website, :created_at, :updated_at, :last_request_at,
                  :external_user_id, :facebook_id, :twitter_id, :blob_id,
                  :custom_data, :twitter_digits_id, :user_tags)
    attr_accessor :password, :session, :token, :token_expiration

    def self.find(id)
      attrs = Qblox::Api::User.new.find_by_id(id)
      self.new attrs['user']
    end

    def self.find_by_external_id(id)
      attrs = Qblox::Api::User.new.find_by_external_id(id)
       self.new attrs['user']
    end

    def self.create(attrs)
      attrs = Qblox::Api::User.new.create(attrs)
      self.new attrs['user']
    end

    def sign_in(password)
      @password = password
      token
    end

    def token
      return @token if token_valid?
      @session = Qblox::Api::Session.new.create(user: session_data)
      @token_expiration = @session['session']['token_expiration']
      @token = @session['session']['token']
    end

    def dialogs
      @dialogs ||= Qblox::Api::Dialog.new(token: token).index
    end

    def send_pvt_message(recipient_id, message, options = {})
      options[:send_to_chat] ||= 1
      options[:markable] ||= 1
      options[:reciptient_id] = recipient_id
      options[:message] = message
      Qblox::Api::Message.new(token: token, user: session_data)
        .create(options)
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
