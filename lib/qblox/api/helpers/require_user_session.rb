module Qblox
  module Api
    module RequireUserSession
      module ClassMethods
      end

      module InstanceMethods
        # This API needs to deal with a user session.
        #
        # So you should pass token, user: { login: '...', password: '***' },
        # or user: { email: '...', password: '***' } to authenticate
        def initialize(opts = {})
          super(opts)
          @opts = opts
        end

        def headers
          super.merge(
            Qblox::Api::Connections::ApiEndpoint::QB_TOKEN_HEADER => token)
        end

        def token
          @token ||= token_from_opts(@opts)
        end

        def token_from_opts(opts = {})
          return opts[:token] if opts[:token]
          user = opts[:user]
          token_for(login: user[:login],
                        password: user[:password],
                        email: user[:email])
        end

        def token_for(login: nil, email: nil, password:)
          if @session &&
              @session['session']['token_expiration'].to_i > Time.now.to_i
            return @session['session']['token']
          end
          if login.nil? && email.nil?
            fail(ArgumentError, 'You should provide login or email to '\
                 'create user session')
          end
          data = { password: password }
          data[:login] = login if login
          data[:email] = email if email
          @session = Session.new.create(user: data)
          @session['session']['token']
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
