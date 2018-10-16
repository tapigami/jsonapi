require "test_helper"

class Article < Jsonapi::Resource
  has_one :author
  has_many :comments
end

class Author < Jsonapi::Resource
end

class Comment < Jsonapi::Resource
  has_one :author
end

class JsonapiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jsonapi::VERSION
  end

  def test_it_does_something_useful
    assert Article.list.last.title == 'JSON API paints my bikeshed!'
  end

  def test_rel
    assert Article.list.last.comments.last.body == 'I like XML better'
  end

  def test_srel
    assert Article.list.last.author.firstName == 'Dan'
  end
end
