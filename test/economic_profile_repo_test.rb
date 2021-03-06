require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile_repository'
require 'rake/testtask'


class EconomicProfileRepoTest < Minitest::Test
  attr_reader  :epr
  def setup
    @epr = EconomicProfileRepository.new
    @epr.load_data({
      :economic_profile => {
      :median_household_income => "./test/test_data/test Median household income.csv",
      :children_in_poverty => "./test/test_data/test School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./test/test_data/test Students qualifying for free or reduced price lunch.csv",
      :title_i => "./test/test_data/test Title I students.csv"}})
  end

  def test_can_load_data
   refute epr.profiles.empty?
  end

  def test_can_find_by_name
    ep = epr.find_by_name("ACADEMY 20")
    assert_instance_of EconomicProfile, ep
  end

  def test_returns_nil_if_name_not_found

  end

end
