require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'rake/testtask'
require './lib/statewide_test_repository'
require './lib/statewide_test'

class StatewideTestRepositoryTest < Minitest::Test

  def test_can_put_load_data
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
    refute str.statewide_testing.empty?
  end

  def test_that_statewide_testing_contains_statewide_test_objects
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
    assert_instance_of StatewideTest, str.statewide_testing[0]
  end

  def test_that_can_find_statewide_test_object_by_name
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
    expected = {:name=>"ACADEMY 20",
      :third_grade=>{2008=>{:writing=>0.671}},
      :eighth_grade=>{2008=>{:reading=>0.843}, 2009=>{:reading=>0.825}},
      :all_students=>{2014=>{:math=>0.69944}},
      :asian=>{2014=>{:math=>0.8}},
      :black=>{2014=>{:math=>0.4205}, 2011=>{:reading=>0.662}},
      :pacific_islander=>{2014=>{:math=>0.6818}, 2011=>{:reading=>0.7451}},
      :hispanic=>{2014=>{:math=>0.6048}, 2011=>{:reading=>0.7486}}}
      statewide_test_object = str.find_by_name("Academy 20")
    assert_equal expected, statewide_test_object.attributes
  end
end
