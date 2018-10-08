# frozen_string_literal: true

module Jsonapi
  class Response
    ATTRUBUTES_KEYS = %i[
      data
      errors
      meta
      jsonapi
      links
      included
    ].freeze

    def initialize(body)
      @body = body
    end

    private

    attr_reader :body

    def respond_to_missing?(symbol, include_private)
      return true if attribute?(name)

      false
    end

    def method_missing(name, *args)
      if attribute?(name)
        attr = body[name] or return nil
        return Marshal.load(Marshal.dump(attr)) 
      end

      super
    end

    def attribute?(name)
      ATTRUBUTES_KEYS.include?(name)
    end
  end
end
