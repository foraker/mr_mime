module MrMime
  module Adapters
    class SorceryAdapter < Base
      def set_current_user(user)
        context.auto_login user
      end
    end
  end
end
