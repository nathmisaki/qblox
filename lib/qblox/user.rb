module Qblox
  class User < Base
    API_ATTRS = [:id, :owner_id, :full_name, :email, :login, :phone,
                 :website, :created_at, :updated_at, :last_request_at,
                 :external_user_id, :facebook_id, :twitter_id, :blob_id,
                 :custom_data, :twitter_digits_id, :user_tags]
    SKIP_UPDATE_ATTRS = Set.new([:id, :created_at, :last_request_at,
                                 :owner_id, :updated_at])
    attr_accessor *API_ATTRS
    attr_accessor :password, :session, :token, :token_expiration
    FIND_EXPIRATION = 24 * 3600
    SESSION_EXPIRATION = 3600

    def self.find(id)
      attrs = Qblox::Cache.instance.fetch("user:find:#{id}", FIND_EXPIRATION) do
        Qblox::Api::User.new.find_by_id(id)
      end
      self.new attrs['user']
    end

    def self.find_by_external_id(id)
      attrs = Qblox::Cache.instance.fetch("user:find_by_external_id:#{id}", FIND_EXPIRATION) do
        Qblox::Api::User.new.find_by_external_id(id)
      end
      self.new attrs['user']
    end

    def self.find_by_email(email)
      attrs = Qblox::Cache.instance.fetch("user:find_by_email:#{email}", FIND_EXPIRATION) do
        Qblox::Api::User.new.find_by_email(email)
      end
      self.new attrs['user']
    end

    def self.find_by_login(login)
      attrs = Qblox::Cache.instance.fetch("user:find_by_login:#{login}", FIND_EXPIRATION) do
        Qblox::Api::User.new.find_by_login(login)
      end
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

    def update
      data = API_ATTRS.each_with_object({}) do |at, hash|
        val = send(at)
        hash[at] = val if !val.nil? && !SKIP_UPDATE_ATTRS.include?(at)
      end.compact
      data[:token] = token
      attrs = Qblox::Api::User.new.update(id, data)
      self.attributes = attrs
    end

    def token
      return @token if token_valid?
      @session = Qblox::Cache.instance.fetch("user:session#{Qblox::Cache.hexdigest(session_data)}", SESSION_EXPIRATION) do
        Qblox::Api::Session.new.create(user: session_data)
      end
      @token_expiration = @session['session']['token_expiration']
      @token = @session['session']['token']
    end

    def dialogs(filters = {})
      return @dialogs unless @dialogs.nil? || filters != {}
      dialogs = Qblox::Api::Dialog.new(token: token).index(filters)
      dialogs = Qblox::Dialog::Collection.new(dialogs, token: token)
      @dialogs = dialogs unless filters != {}
      dialogs
    end

    def messages_from_dialog(chat_dialog_id, options: {})
      dialog = Qblox::Dialog.new(id: chat_dialog_id, token: token)
      dialog.messages(options: options)
    end

    def create_dialog(attrs = {})
      data = Qblox::Api::Dialog.new(token: token).create(attrs)
      Qblox::Dialog.new(data)
    end

    def delete_dialog(chat_dialog_id, options = {})
      Qblox::Api::Dialog.new(token: token).delete(chat_dialog_id, options)
    end

    def send_custom_pvt_message(recipient_id, options = {})
      options[:send_to_chat] ||= 1
      options[:save_to_history] ||= 1
      options[:markable] ||= 1
      options[:recipient_id] = recipient_id
      Qblox::Message.new(
        Qblox::Api::Message.new(token: token, user: session_data)
        .create(options))
    end

    def send_pvt_message(recipient_id, message, options = {})
      options[:send_to_chat] ||= 1
      options[:save_to_history] ||= 1
      options[:markable] ||= 1
      options[:recipient_id] = recipient_id
      options[:message] = message
      Qblox::Message.new(
        Qblox::Api::Message.new(token: token, user: session_data)
        .create(options))
    end

    def send_message(chat_dialog_id, message, options = {})
      options[:send_to_chat] ||= 1
      options[:save_to_history] ||= 1
      options[:markable] ||= 1
      options[:chat_dialog_id] = chat_dialog_id
      options[:message] = message
      Qblox::Message.new(
        Qblox::Api::Message.new(token: token, user: session_data)
        .create(options)
      )
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
