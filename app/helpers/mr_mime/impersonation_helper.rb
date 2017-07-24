module MrMime
  module ImpersonationHelper
    def button_to_impersonate(user_id, options = {})
      render 'mr_mime/impersonate_button', options.merge(user_id: user_id)
    end

    def impersonated_email
      current_user.try(:email)
    end
  end
end
