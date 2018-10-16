# frozen_string_literal: true

require 'active_support/concern'

require 'jsonapi/response'

module Jsonapi
  module RestOperation
    extend ActiveSupport::Concern

    class_methods do
      def list
        response = client.get 'quotes'
        body = response.body
        json = JSON.parse(body, { symbolize_names: true })
        res = Response.new(json)
        res.data.map { |e| self.new(e, { included: res.included }) }
      end

      def find
      end

      def create
      end
    end

    def update
    end

    def destroy
    end
  end
end
