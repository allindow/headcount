require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require 'rake/testtask'

class EconomicProfileTest < Minitest::Test
  attr_reader  :epr, :ep
  def setup
    @epr = EconomicProfileRepository.new
    @epr.load_data({
      :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
       }
      })
    @ep = @epr.find_by_name("Academy 20")
  end

  def test_can_instantiates_with_economic_data
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)
    assert_equal data, economic_profile.attributes
  end

  def test_can_get_median_household_income_in_year
    skip
    assert_equal 0, ep.median_household_income_in_year(2005)
    assert_equal 0, ep.median_household_income_in_year(2009)
  end

  def test_unknown_year_raises_unknown_data_error
    skip
    assert_raises(UnknownDataError) do
      ep.median_household_income_in_year(2016)
    end
  end

  def test_can_get_median_household_income_average
    skip
    assert_equal 0,ep.median_household_income_average
  end

  def test_can_get_children_in_poverty_in_year
    skip
    assert_equal 0, ep.children_in_poverty_in_year(2012)
    assert_equal 0, ep.children_in_poverty_in_year(2009)
  end

  def test_unknown_year_for_children_poverty_raises_error
    skip
    assert_raises(UnknownDataError) do
      ep.children_in_poverty_in_year(1987)
    end
  end

  def test_can_get_free_or_reduced_price_lunch_percentage_in_year
    skip
    assert_equal 0.0,ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_unknown_year_for_lunch_data_raises_error
    skip
    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_percentage_in_year(2020)
    end
  end

  def test_can_get_free_reduced_lunch_data_in_year
    skip
    assert_equal 900, ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_unknown_year_for_lunch_in_year_raises_error
    skip
    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_number_in_year(2030)
    end
  end

  def test_can_get_title_i_in_year
    skip
    assert_equal 0.777, ep.title_i_in_year(2015)
  end

  def test_unknown_year_for_title_i_raises_error
    skip
    assert_raises(UnknownDataError) do
      ep.title_i_in_year(1870)
    end
  end

end
