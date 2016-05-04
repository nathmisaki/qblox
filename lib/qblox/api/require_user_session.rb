module Qblox
  module Api
    module RequireUserSession
      module ClassMethods
      end

      module InstanceMethods
        def get_token_for(login: nil, email: nil, password:)
          return @session['session']['token'] if @session
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
