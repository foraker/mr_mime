module MrMime
  class UrlResolver
    delegate :main_app, to: :context, allow_nil: true

    def self.resolve(*args)
      new(*args).resolve
    end

    def initialize(url, options = {})
      @url = evaluate(url, *options[:args])
      @context = options[:context]
      @default = options[:default]
    end

    def resolve
      case
      when method_name? then main_app.send(url)
      when url_name?    then url
      else default
      end
    end

    private

    attr_reader :url, :context, :default

    def method_name?
      url.is_a?(Symbol)
    end

    def url_name?
      url.is_a?(String)
    end

    def evaluate(url, *args)
      url.is_a?(Proc) ? url.call(*args) : url
    end
  end
end
