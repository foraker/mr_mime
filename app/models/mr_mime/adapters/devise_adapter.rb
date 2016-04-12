module MrMime
  module Adapters
    class DeviseAdapter < Base
      def set_current_user(user)
        context.sign_out
        context.sign_in(user)
      end
    end
  end
end
