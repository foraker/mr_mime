require 'active_model'

module MrMime
  class Impersonation
    extend ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Conversion

    validates :impersonator, :impersonated, presence: true
    validate :impersonation_allowed

    delegate :user_class, :adapter_class, to: MrMime::Config
    delegate :set_current_user, to: :adapter

    attr_reader :return_to

    def initialize(options = {})
      @adapter   = adapter_class.new(options.fetch(:context))
      @store     = MrMime::Store.new(options[:store] || {})
      @params    = options[:params] || {}
      @return_to = store.get(:return_to)
    end

    def save
      if valid?
        set_user_keys
        true
      end
    end

    def revert
      revert_user_keys
    end

    def impersonator
      @impersonator ||= find_user(params[:impersonator_id])
    end

    def impersonated
      @impersonated ||= find_user(params[:impersonated_id])
    end

    def error_messages
      errors.full_messages.join(', ')
    end

    private

    attr_reader :adapter, :store, :params

    def set_user_keys
      set_current_user impersonated
      store.set_keys(
        impersonator_id: impersonator.id,
        return_to:       params[:referer]
      )
    end

    def revert_user_keys
      set_current_user impersonator
      store.set_keys(
        impersonator_id: nil,
        return_to:       nil
      )
    end

    def impersonation_allowed
      unless impersonation_allowed?
        errors.add(:base, 'You do not have permission to impersonate this user')
      end
    end

    def impersonation_allowed?
      MrMime::ImpersonationPolicy.allowed?(impersonator, impersonated)
    end

    def find_user(id)
      user_class.find_by(id: id)
    end

    def persisted?
      false
    end
  end
end
