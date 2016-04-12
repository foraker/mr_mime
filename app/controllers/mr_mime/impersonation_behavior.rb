module MrMime
  module ImpersonationBehavior
    def self.included(base)
      base.helper_method :current_impersonator, :impersonator?, :impersonator_id
      base.helper MrMime::ImpersonationHelper
    end

    def current_impersonator
      MrMime::Config.user_class.find_by(id: impersonator_id) if impersonator?
    end

    def impersonator?
      impersonator_id.present?
    end

    def impersonator_id
      session['mr_mime.impersonator_id']
    end
  end
end
