module MrMime
  class Engine < ::Rails::Engine
    isolate_namespace MrMime

    initializer 'mr_mime', before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount MrMime::Engine, at: '/mr_mime'
      end
    end
  end
end
