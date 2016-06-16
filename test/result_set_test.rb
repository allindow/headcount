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
require './lib/result_entry'
require './lib/result_set'

class ResultSetTest < Minitest::Test

  def test_that_result_set_instantiated_with_collection_of_result_entry_objects
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6})
    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)
    assert_instance_of ResultSet, rs
  end

  def test_can_get_free_and_reduced_price_lunch_rate
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
      children_in_poverty_rate: 0.25,
      high_school_graduation_rate: 0.75})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
      children_in_poverty_rate: 0.2,
      high_school_graduation_rate: 0.6})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    assert_equal 0.5, rs.matching_districts.first.free_and_reduced_price_lunch_rate # => 0.5
    assert_equal 0.3, rs.statewide_average.free_and_reduced_price_lunch_rate # => 0.3
  end

  def test_can_get_free_and_reduced_price_lunch_rate
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
      children_in_poverty_rate: 0.25,
      high_school_graduation_rate: 0.75})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
      children_in_poverty_rate: 0.2,
      high_school_graduation_rate: 0.6})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    assert_equal 0.5, rs.matching_districts.first.free_and_reduced_price_lunch_rate # => 0.5
    assert_equal 0.3, rs.statewide_average.free_and_reduced_price_lunch_rate # => 0.3
  end

  def test_can_get_children_in_poverty_rate
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
      children_in_poverty_rate: 0.25,
      high_school_graduation_rate: 0.75})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
      children_in_poverty_rate: 0.2,
      high_school_graduation_rate: 0.6})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    assert_equal 0.25, rs.matching_districts.first.children_in_poverty_rate
    assert_equal 0.2, rs.statewide_average.children_in_poverty_rate # => 0.2
  end

  def test_can_get_high_school_graduation_rates
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
      children_in_poverty_rate: 0.25,
      high_school_graduation_rate: 0.75})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
      children_in_poverty_rate: 0.2,
      high_school_graduation_rate: 0.6})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)
    assert_equal 0.75, rs.matching_districts.first.high_school_graduation_rate
    assert_equal 0.6, rs.statewide_average.high_school_graduation_rate
  end

end
