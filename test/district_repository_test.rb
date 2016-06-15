require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/district'
require 'rake/testtask'


class DistrictRepositoryTest < Minitest::Test

  def test_that_load_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
        }
      })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
  end

  def test_find_by_name
    d1 = District.new({:name => "ACADEMY 20"})
    d2 = District.new({:name => "PIZZA 30"})
    dr         = DistrictRepository.new([d1, d2])
    assert_equal d1, dr.find_by_name("Academy 20")
    assert_nil(dr.find_by_name("WHAT"))
  end

  def test_find_all_matching_finds_one
    d1 = District.new({:name => "ACADEMY 20"})
    d2 = District.new({:name => "PIZZA 30"})
    d3 = District.new({name: "Horace's school of pizza"})
    d4 = District.new({:name => "ACADEMY"})
    dr = DistrictRepository.new([d1, d2, d3, d4])
    result = dr.find_all_matching ("acadeMy")
    assert_equal [d1, d4], result
  end

  def test_find_all_matching_returns_empty_array_if_no_match_found
    d1 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepository.new([d1])
    no_result = dr.find_all_matching ("hot dog school")
    assert_equal [], no_result
  end

  def test_new_instance_of_enrollment_repo_created_when_loading_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
        }
        })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end

  def test_that_grade_level_exist
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
        }
        })
      refute dr.grade_level_exist?('Calhan RJ-1', :high_school_graduation)
  end

  def test_load_data_creates_new_statewide_test_objects
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_instance_of StatewideTest, district.statewide_test
  end

  def test_load_data_creates_new_statewide_test_and_enrollment_objects
    dr = DistrictRepository.new
    dr.load_data({
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
    }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_instance_of Enrollment, district.enrollment
    assert_instance_of StatewideTest, district.statewide_test
  end

  def test_load_data_creates_enrollment_and_statewide_objects_with_data
    dr = DistrictRepository.new
    dr.load_data({
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
    }
    })
    district = dr.find_by_name("ACADEMY 20")
    refute district.enrollment.attributes.keys.empty?
    refute district.statewide_test.attributes.keys.empty?
  end

  def test_load_data_creates_enrollment_and_statewide_objects_with_data
    skip
    dr = DistrictRepository.new
    dr.load_data({
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
    district = dr.find_by_name("ACADEMY 20")
    refute district.enrollment.attributes.keys.empty?
    assert_instance_of Enrollment, district.enrollment
    refute district.statewide_test.attributes.keys.empty?
    assert_instance_of StatewideTest, district.statewide_test
    refute district.economic_profile.attributes.keys.empty?
    assert_instance_of EconomicProfile, ditrict.economic_profile
  end

end
