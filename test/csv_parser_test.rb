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
      :kindergarten => "./test/test_data/test_kinder_full_day.csv"
      }
    }
    result = [{:name=>"COLORADO"}, {:name=>"ACADEMY 20"}, {:name=>"CALHAN RJ-1"}, {:name=>"GRANADA RE-1"}, {:name=>"GREELEY 6"}]
    assert_equal result, district_repo_parser(file_tree)
  end

  def test_district_parser_only_has_one_instance_of_name
    file_tree = {
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
        }
      }
      result = district_repo_parser(file_tree)
      assert_equal 5, result.count
  end

  def test_group_names
    input = [{:name => "hi"}, {:name => "lol"}, {:name => "hi"}]
    output = {"HI"=>[{:name=>"hi"}, {:name=>"hi"}], "LOL"=>[{:name=>"lol"}]}

    assert_equal output, group_names(input)
  end

  def test_that_loads_enrollment_names
    file_tree = {
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
        }
      }
      result = [{:name=>"COLORADO", :kindergarten_participation=>{2007=>0.39465, 2006=>0.5675}}, {:name=>"ACADEMY 20", :kindergarten_participation=>{2010=>0.4362, 2008=>0.38456}}, {:name=>"CALHAN RJ-1", :kindergarten_participation=>{2011=>1.0, 2012=>1.0}}, {:name=>"GRANADA RE-1", :kindergarten_participation=>{2007=>1.0}}, {:name=>"GREELEY 6", :kindergarten_participation=>{2008=>0.05863}}]
    assert_equal result, enrollment_repo_parser(file_tree)
    end

  def test_that_loads_only_one_instance_of_an_enrollment_district_name
    file_tree = {
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
        }
      }
    assert_equal 5, enrollment_repo_parser(file_tree).count
  end

  def test_that_loads_high_school_data_and_kindergarten_data
    file_tree = {
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
        }
      }
      i = file_tree.values[0].values.count
    assert_equal i, 2
  end

  #need to have better tests for this
  #edge cases to test:
  #test that it only returns one instance of the district name

end
