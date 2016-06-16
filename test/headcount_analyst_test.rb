require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'rake/testtask'
require './lib/headcount_analyst'
require './lib/district_repository'
require './lib/result_entry'
require './lib/result_set'
require './lib/economic_profile_repository'

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

  def test_that_rate_calc_returns_average
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
      hca = HeadcountAnalyst.new(dr)
    correct_district = dr.find_by_name('Academy 20')
    assert_equal 0.406, hca.rate_calc(correct_district, :kindergarten)
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
        :kindergarten => "./test/test_data/test_kinder_full_day.csv",
        :high_school_graduation => "./test/test_data/test_hs_grad.csv"
        }
      })
    hca = HeadcountAnalyst.new(dr)
    participation_rate = hca.graduation_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 1.203, participation_rate
  end

  def test_that_can_find_kindergarten_graduation_variation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv",
        :high_school_graduation => "./test/test_data/test_hs_grad.csv"
        }
      })
    ha = HeadcountAnalyst.new(dr)
  assert_equal 0.709, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_determines_correlation_between_data_variation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv",
        :high_school_graduation => "./test/test_data/test_hs_grad.csv"
        }
      })
    ha = HeadcountAnalyst.new(dr)
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_can_determine_correlation_statewide
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv",
        :high_school_graduation => "./test/test_data/test_hs_grad.csv"
        }
      })
    ha = HeadcountAnalyst.new(dr)
  refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
 end

 def test_can_compare_multiple_districts
   dr = DistrictRepository.new
   dr.load_data({
     :enrollment => {
       :kindergarten => "./test/test_data/test_kinder_full_day.csv",
       :high_school_graduation => "./test/test_data/test_hs_grad.csv"
       }
     })
   ha = HeadcountAnalyst.new(dr)
   refute ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['Academy 20', 'Greeley 6'])
 end
end

class EconomicProfileAnalysisTest < Minitest::Test
  attr_reader :ha, :dr
  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv",
    },
      :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    },
      :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
    }
    })
    @ha = HeadcountAnalyst.new(dr)
  end

  def test_can_get_statewide_average_for_free_reduced_lunch
    assert_equal 1575.0, ha.statewide_lunch_average
  end

  def test_can_get_statewide_average_for_children_in_poverty
    assert_equal 0.164, ha.sw_children_in_poverty_average
  end

  def test_can_get_statewide_hs_grad_average
   assert_equal 0.751, ha.statewide_hs_grad_average
  end

  def test_can_get_district_averages_for_free_reduced_lunches
    district = dr.find_by_name("Adams county 14")
    assert_equal 5241, ha.lunch_average(district)
  end

  def test_can_create_result_set_with_high_poverty_and_high_school_grade_matches
    rs = ha.high_poverty_and_high_school_graduation
    assert_instance_of ResultSet, rs
    assert_equal 2, rs.matching_districts.count
    assert_instance_of ResultEntry, rs.matching_districts.first
  end

  def test_match_has_rate_data
    rs = ha.high_poverty_and_high_school_graduation
    assert_equal 2296, rs.matching_districts.first.free_and_reduced_price_lunch_rate
    assert_equal 0.176, rs.matching_districts.first.children_in_poverty_rate
    assert_equal 0.832, rs.matching_districts.first.high_school_graduation_rate
    assert_instance_of ResultEntry, rs.statewide_average
    assert_equal 1575, rs.statewide_average.free_and_reduced_price_lunch_rate
    assert_equal 0.164, rs.statewide_average.children_in_poverty_rate
    assert_equal 0.751,  rs.statewide_average.high_school_graduation_rate
  end

  def test_can_get_statewide_median_household_income_average
    assert_equal 57408, ha.statewide_median_household_income
  end

  def test_can_get_district_median_house_income_average
    district = dr.find_by_name("Adams county 14")
    assert_equal 41305, ha.median_income(district)
  end

  def test_can_create_result_set_with_median_income_and_poverty
    rs = ha.high_income_and_poverty
    assert_instance_of ResultSet, rs
    assert_equal 2, rs.matching_districts.count
    assert_instance_of ResultEntry, rs.matching_districts.first
  end

  def test_income_poverty_match_has_rate_data
    rs = ha.high_income_and_poverty
    assert_equal 63265, rs.matching_districts.first.median_household_income
    assert_equal 0.205, rs.matching_districts.first.children_in_poverty_rate
    assert_instance_of ResultEntry, rs.statewide_average
    assert_equal 57408.0, rs.statewide_average.median_household_income
    assert_equal 0.164, rs.statewide_average.children_in_poverty_rate
  end

  def test_kinder_part_against_household_income
    district = dr.find_by_name("Adams county 14")
    assert_equal 1.855, ha.kindergarten_participation_against_household_income(district)
  end

  def test_kinder_part_against_household_income
    district = dr.find_by_name("Adams county 14")
    assert_equal 1.855, ha.kindergarten_participation_against_household_income(district)
  end

  def test_kinder_correlates_with_household_income
    refute ha.kindergarten_participation_correlates_with_household_income(for: 'Adams county 14')
    refute ha.kindergarten_participation_correlates_with_household_income(for: 'academy 20')
  end

  def test_statewide_kinder_correlates_with_household_income
    refute ha.kindergarten_participation_correlates_with_household_income(for: 'STATEWIDE')
  end

  def test_kinder_correlates_with_household_income_across_districts
    assert ha.kindergarten_participation_correlates_with_household_income(:across => ['ACADEMY 20', 'YUMA SCHOOL DISTRICT 1', 'WILEY RE-13 JT', 'SPRINGFIELD RE-4'])
  end


end
