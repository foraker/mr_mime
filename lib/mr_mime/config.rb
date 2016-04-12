module MrMime
  module Config
    mattr_accessor :adapter
    @@adapter = :devise

    mattr_accessor :user_model
    @@user_model = 'User'

    mattr_accessor :user_permission_check
    @@user_permission_check = nil

    def self.adapters
      {
        sorcery: MrMime::Adapters::SorceryAdapter,
        devise:  MrMime::Adapters::DeviseAdapter
      }
    end

    def self.adapter_class
      @@adapter_class ||= adapters[@@adapter]
    end

    def self.user_class
      @@user_class ||= user_model.constantize
    end
  end
end
