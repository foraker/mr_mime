module MrMime
  class ImpersonationsController < MrMime::ApplicationController
    before_action :require_login

    def create
      if impersonation.save
        redirect_to after_impersonation_url, notice: 'Impersonation started'
      else
        redirect_to :back, flash: { error: impersonation.error_messages }
      end
    end

    def destroy
      impersonation.revert

      redirect_to impersonation.return_to, notice: 'Impersonation ended'
    end

    private

    def impersonation
      @impersonation ||= MrMime::Impersonation.new(
        context: self,
        store: session,
        params: impersonation_params
      )
    end

    def impersonation_params
      params.fetch(:impersonation, {})
        .merge(
          impersonator_id: impersonator.id,
          referer: request.referer
        )
    end

    def impersonator
      current_impersonator || current_user
    end

    def require_login
      unless current_user
        redirect_to main_app.root_url, flash: {
          error: 'You do not have permission to do this'
        }
      end
    end

    def after_impersonation_url
      MrMime::UrlResolver.resolve(
        MrMime::Config.after_impersonation_url,
        context: self,
        args: current_user,
        default: main_app.root_url
      )
    end
  end
end
