require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'rake/testtask'
require './lib/statewide_test_repository'
require './lib/statewide_test'

class StatewideTestRepositoryTest < Minitest::Test

  def test_can_find_by_name
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
      :third_grade => "./test/test_data/test 3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./test/test_data/test 8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    assert_instance_of StatewideTest, str.find_by_name("ACADEMY 20")
  end

end
