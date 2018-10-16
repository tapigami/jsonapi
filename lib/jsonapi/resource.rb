# frozen_string_literal: true


require 'jsonapi/rest_operation'
require 'jsonapi/client'
require 'jsonapi/relationship'

module Jsonapi
  class Resource
    class << self
      attr_reader :has_relationship

      def has_one(name)
        @has_relationship = true
      end

      def has_many(name)
        @has_relationship = true
      end
    end
    include RestOperation
    include Relationship
    extend Client

    def initialize(hash, options = {})
      @id            = hash[:id]
      @attributes    = hash[:attributes]
      @links         = hash[:links]
      @meta          = hash[:meta]
      @included      = options[:included] || []
      super
    end

    private

    attr_reader :id, :attributes, :links, :meta, :included

    def respond_to_missing?(symbol, include_private)
      return true if attribute?(symbol)
      return true if self.class.has_relationship && relationship?(symbol)

      false
    end

    def method_missing(name)
      if attribute?(name)
        attributes[name]
      elsif self.class.has_relationship && relationship?(name)
        relationship(name)
      else
        super
      end
    end

    def attribute?(name)
      attributes.has_key?(name)
    end
  end
end
