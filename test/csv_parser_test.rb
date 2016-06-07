require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/district'
require './lib/csv_parser'


class CSVParserTest < Minitest::Test
  include CSVParser

def test_that_load_districts
  file_tree = {
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    }
    assert_equal "", district_repo_parser(file_tree)
  end

end
