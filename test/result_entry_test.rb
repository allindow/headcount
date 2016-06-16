require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/district'
require './lib/statewide_parser'
require './lib/enrollment_repository'
require './lib/enrollment'
require './lib/district_parser'
require './lib/enrollment_parser'
require './lib/economic_parser'
require './lib/result_set'
require './lib/result_entry'

class ResultEntryTest < Minitest::Test

  def test_instantiates_with_hash_representing_results
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
    assert_equal 0.5, r1.attributes[:free_and_reduced_price_lunch_rate]
    assert_equal 0.25, r1.attributes[:children_in_poverty_rate]
    assert_equal 0.75, r1.attributes[:high_school_graduation_rate]
    assert_nil r1.attributes[:median_household_income]
  end

  def test_finds_free_and_reduced_price_lunch_rate
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
    assert_equal 0.5, r1.free_and_reduced_price_lunch_rate
  end

  def test_finds_children_in_poverty_rate
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
    assert_equal 0.25, r1.children_in_poverty_rate
  end

  def test_finds_high_school_graduation_rate
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
    assert_equal 0.75, r1.high_school_graduation_rate
  end

end
