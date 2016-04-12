require 'mr_mime/engine'
require 'mr_mime/version'
require 'mr_mime/config'

module MrMime
  def self.configure
    yield MrMime::Config
  end
end
