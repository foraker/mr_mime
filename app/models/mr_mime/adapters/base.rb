module MrMime
  module Adapters
    class Base
      def initialize(context)
        @context = context
      end

      private

      attr_reader :context
    end
  end
end
