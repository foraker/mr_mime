require 'rails/generators/base'
require 'securerandom'

module MrMime
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Creates a MrMime initializer'

      def copy_initializer
        template 'mr_mime.rb', 'config/initializers/mr_mime.rb'
      end
    end
  end
end
