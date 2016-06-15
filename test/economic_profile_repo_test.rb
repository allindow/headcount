require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile_repository'
require 'rake/testtask'

class EconomicProfileRepoTest < Minitest::Test

  def test_can_load_data
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"}})
    refute epr.profiles.empty?
  end

  def test_can_find_by_name
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"}})
    refute epr.economic_profile.empty?
    ep = epr.find_by_name("ACADEMY 20")
    expected =
    assert_instance_of EconomicProfile, ep
    assert_equal result, ep
  end

end
