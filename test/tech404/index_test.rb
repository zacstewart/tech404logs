require 'test_helper'

class Tech404::IndexTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Tech404::Index::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
