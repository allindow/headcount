require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/district'
require './lib/csv_parser'
require './lib/enrollment_repository'
require './lib/enrollment'


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

  def test_that_loads_enrollment_names
    file_tree = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      }
    assert_equal "", enrollment_repo_parser(file_tree)
    end
  #need to have better tests for this
  #edge cases to test:
  #test that it only returns one instance of the district name

end
