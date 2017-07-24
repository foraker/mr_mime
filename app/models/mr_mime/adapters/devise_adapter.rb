module MrMime
  module Adapters
    class DeviseAdapter < Base
      delegate :user_class, to: MrMime::Config

      def set_current_user(user)
        context.sign_out
        context.sign_in user.becomes(user_class)
      end
    end
  end
end
