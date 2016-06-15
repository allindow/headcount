require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'rake/testtask'
require './lib/statewide_test_repository'
require './lib/statewide_test'
require './lib/helper'

class StatewideTestTest < Minitest::Test
  attr_reader :str

  def setup
    @str = StatewideTestRepository.new
    @str.load_data({
      :statewide_testing => {
      :third_grade => "./test/test_data/test 3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./test/test_data/test 8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
  end

  def test_can_get_third_grade_data

    statewide_test = str.find_by_name("colorado")
    expected = {2008=>{:math=>0.697, :reading=>0.703},
      2009=>{:writing=>0.536}, 2010=>{:writing=>0.504},
      2011=>{:math=>0.696}}
    assert_equal expected, statewide_test.proficient_by_grade(3)
  end

  def test_can_get_eighth_grade_data

    statewide_test = str.find_by_name("ACADEMY 20")
    expected = {2008=>{:reading=>0.843}, 2009=>{:reading=>0.825}}
    assert_equal expected, statewide_test.proficient_by_grade(8)
  end

  def test_raises_unknown_data_error_if_not_valid_grade
    statewide_test = str.find_by_name("ACADEMY 20")
    assert_raises(UnknownDataError) do statewide_test.proficient_by_grade(5)
    end
  end

  def test_can_get_data_by_race
    statewide_test = str.find_by_name("academy 20")
    pacific        = {2014=>{:math=>0.681}, 2011=>{:reading=>0.745}}
    assert_equal pacific, statewide_test.proficient_by_race_or_ethnicity(:pacific_islander)
    statewide_test = str.find_by_name("colorado")
    two_or_more    = {2012=>{:reading=>0.760}}
    assert_equal two_or_more, statewide_test.proficient_by_race_or_ethnicity(:two_or_more)
  end

  def test_raises_unknown_race_error_if_not_valid_race
    statewide_test = str.find_by_name("colorado")
    assert_raises(UnknownRaceError) do statewide_test.proficient_by_race_or_ethnicity(:guamanian)
    end
  end

  def test_can_get_percentage_by_grade_year_and_subject_per_district
    statewide_test = str.find_by_name("colorado")
    assert_equal 0.697, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    assert_equal 0.499, statewide_test.proficient_for_subject_by_grade_in_year(:math, 8, 2009)
  end

  def test_unknown_data_error_if_parameter_for_subject_by_grade_in_year_invalid
    statewide_test = str.find_by_name("colorado")
    assert_raises(UnknownDataError) do statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2000)
    end
  end

  def test_can_get_percentage_for_subject_by_race_in_year
    statewide_test = str.find_by_name("colorado")
    assert_equal 0.709, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2011)
  end

  def test_unknown_data_error_for_parameter_for_percentage_for_subject_by_race_in_year_invalid
    statewide_test = str.find_by_name("colorado")
    assert_raises(UnknownDataError) do statewide_test.proficient_for_subject_by_race_in_year(:reading, :asian, 2011)
    end
  end

end
