require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'rake/testtask'
require './lib/headcount_analyst'
require './lib/district_repository'
# require 'pry'


class HeadcountAnalystTest < Minitest::Test

  def test_is_initialized_with_district_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
        }
      })
      hca = HeadcountAnalyst.new(dr)
    assert_instance_of DistrictRepository, hca.dr
  end

  def test_that_hca_has_district_content
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
        }
      })
      hca = HeadcountAnalyst.new(dr)
    refute hca.dr.districts.empty?
  end

  def test_that_rate_calculator_returns_average
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
      hca = HeadcountAnalyst.new(dr)
    correct_district = dr.find_by_name('Academy 20')
    assert_equal 0.406, hca.rate_calculator(correct_district, :kindergarten)
  end

  def test_that_state_kindergarten_participation_rate_is_compared_to_state
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
      hca = HeadcountAnalyst.new(dr)
    participation_rate = hca.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.766, participation_rate
  end

  def test_that_district_participation_rates_are_compared
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
      hca = HeadcountAnalyst.new(dr)
    participation_rate = hca.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_equal 0.446, participation_rate
  end

  def test_that_can_compare_kindergarten_participation_rate_trend
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
      hca = HeadcountAnalyst.new(dr)
    participation_trend = hca.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    result = [{2007=>0.695}, {2006=>0.676}, {2005=>0.633}, {2004=>0.151}, {2008=>0.692}, {2009=>0.695}, {2010=>0.718}, {2011=>0.744}, {2012=>0.739}, {2013=>0.743}, {2014=>0.745}]
    assert_equal result, participation_trend
  end

  def test_that_can_find_high_school_graduation_variation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :high_school_graduation => "./test/test_data/test_hs_grad.csv"}})
    hca = HeadcountAnalyst.new(dr)
    participation_rate = hca.graduation_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.719, participation_rate
  end
end
