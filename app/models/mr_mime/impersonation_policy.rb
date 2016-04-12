module MrMime
  class ImpersonationPolicy
    delegate :user_permission_check, to: MrMime::Config

    attr_reader :impersonator, :impersonated

    def self.allowed?(*args)
      new(*args).allowed?
    end

    def initialize(impersonator, impersonated)
      @impersonator = impersonator
      @impersonated = impersonated
    end

    def allowed?
      return true unless user_permission_check

      impersonator.public_send(user_permission_check)
    end
  end
end
