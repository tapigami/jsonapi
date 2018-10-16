# frozen_string_literal: true

require 'json'

require 'active_support/core_ext/string/inflections'

module Jsonapi
  module Relationship
    def initialize(hash, options = {})
      @relationships = hash[:relationships]
      @loaded_relationship = []
      super()
    end

    attr_reader :relationships, :loaded_relationship

    def relationship?(name)
      relationships.has_key?(name)
    end

    def relationship(name)
      if relationships[name][:data].respond_to?(:to_ary)
        relationships[name][:data].map do |r|
          found = relationship_array.find { |h| h[:type] == r[:type] && h[:id] == r[:id] }
          unless found
            load_relationship(name)
            found = relationship_array.find { |h| h[:type] == r[:type] && h[:id] == r[:id] }
          end
          name.to_s.classify.constantize.new(found)
        end
      else
        r = relationships[name][:data]
        found = relationship_array.find { |h| h[:type] == r[:type] && h[:id] == r[:id] }
        unless found
          load_relationship(name)
          found = relationship_array.find { |h| h[:type] == r[:type] && h[:id] == r[:id] }
        end
        name.to_s.classify.constantize.new(found)
      end
    end

    def load_relationship(name)
      relationship = relationships[name]
      if relationship[:links]
        # relationship[:links][:related]
        @loaded_relationship += JSON.parse(INCLUDED, { symbolize_names: true })
      else
        if relationship[:data].respond_to?(:to_ary)
          relationship[:data].to_ary.each do
            # get resource by id each
          end
        else
          # get resource by id
        end
      end
    end

    def relationship_array
      included + loaded_relationship
    end
  end
end
