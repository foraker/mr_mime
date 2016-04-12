module MrMime
  class Store < SimpleDelegator
    PREFIX = 'mr_mime'

    def set_keys(values = {})
      values.each{ |k,v| set(k, v) }
    end

    def set(key, value)
      self["#{PREFIX}.#{key}"] = value
    end

    def get(key)
      self["#{PREFIX}.#{key}"]
    end
  end
end
