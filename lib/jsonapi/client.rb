# frozen_string_literal: true

require 'faraday'

module Jsonapi
  module Client
    def client
      HttpClient.new
    end

    class HttpClient
      def initialize
        @client = Faraday.new(:url => 'http://localhost:4435/api/v2') do |con|
          con.authorization :Bearer, '3c0841c46a4b75baa342529745d1696951b596c111113f95250ba1d31f837560'
          con.adapter  Faraday.default_adapter
        end
      end

      def get(hoge)
        @client.get hoge

        hoge = Object.new
        def hoge.body
          PAYLOAD
        end
        hoge
      end
    end
  end

INCLUDED = <<INCLUDED
[
    {
      "attributes": {
        "firstName": "Dan",
        "lastName": "Gebhardt",
        "twitter": "dgeb"
      },
      "id": "9",
      "links": {
        "self": "http://example.com/people/9"
      },
      "type": "people"
    },
    {
      "attributes": {
        "body": "First!"
      },
      "id": "5",
      "links": {
        "self": "http://example.com/comments/5"
      },
      "relationships": {
        "author": {
          "data": {
            "id": "2",
            "type": "people"
          }
        }
      },
      "type": "comments"
    },
    {
      "attributes": {
        "body": "I like XML better"
      },
      "id": "12",
      "links": {
        "self": "http://example.com/comments/12"
      },
      "relationships": {
        "author": {
          "data": {
            "id": "9",
            "type": "people"
          }
        }
      },
      "type": "comments"
    }
  ]
INCLUDED
PAYLOAD = <<JSON
{
  "data": [
    {
      "attributes": {
        "title": "JSON API paints my bikeshed!"
      },
      "id": "1",
      "links": {
        "self": "http://example.com/articles/1"
      },
      "relationships": {
        "author": {
          "data": {
            "id": "9",
            "type": "people"
          },
          "links": {
            "related": "http://example.com/articles/1/author",
            "self": "http://example.com/articles/1/relationships/author"
          }
        },
        "comments": {
          "data": [
            {
              "id": "5",
              "type": "comments"
            },
            {
              "id": "12",
              "type": "comments"
            }
          ],
          "links": {
            "related": "http://example.com/articles/1/comments",
            "self": "http://example.com/articles/1/relationships/comments"
          }
        }
      },
      "type": "articles"
    }
  ],
  "links": {
    "last": "http://example.com/articles?page[offset]=10",
    "next": "http://example.com/articles?page[offset]=2",
    "self": "http://example.com/articles"
  }
}
JSON
end
