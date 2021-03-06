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


class CSVParserTest < Minitest::Test
  include StatewideParser, DistrictParser, EnrollmentParser, EconomicParser

  def test_that_district_parser_load_districts
    file_tree = {
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
      }
    }
    result = [{:name=>"COLORADO"}, {:name=>"ACADEMY 20"}, {:name=>"CALHAN RJ-1"}, {:name=>"GRANADA RE-1"}, {:name=>"GREELEY 6"}]
    assert_equal result, district_repo_parser(file_tree)
  end

  def test_district_parser_only_has_one_instance_of_name
    file_tree = {
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
      }
    }
    result = district_repo_parser(file_tree)
    assert_equal 5, result.count
  end

  def test_group_names
    input = [{:name => "hi"}, {:name => "lol"}, {:name => "hi"}]
    output = {"HI"=>[{:name=>"hi"}, {:name=>"hi"}], "LOL"=>[{:name=>"lol"}]}

    assert_equal output, group_names(input)
  end

  def test_that_enrollment_parser_loads_enrollment_names
    file_tree = {
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
      }
    }
    result = [{:name=>"COLORADO", :kindergarten_participation=>{2007=>0.39465, 2006=>0.5675}}, {:name=>"ACADEMY 20", :kindergarten_participation=>{2010=>0.4362, 2008=>0.38456}}, {:name=>"CALHAN RJ-1", :kindergarten_participation=>{2011=>1.0, 2012=>1.0}}, {:name=>"GRANADA RE-1", :kindergarten_participation=>{2007=>1.0}}, {:name=>"GREELEY 6", :kindergarten_participation=>{2008=>0.05863}}]
    assert_equal result, enrollment_repo_parser(file_tree)
  end

  def test_enrollment_parser_loads_only_one_instance_of_an_enrollment_district_name
    file_tree = {
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
      }
    }
    assert_equal 5, enrollment_repo_parser(file_tree).count
  end

  def test_enrollment_parser_can_get_how_many_files_are_in_file_tree
    file_tree = {
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv",
        :high_school_graduation => "./test/test_data/test_hs_grad.csv"
      }
    }
    i = file_tree.values[0].values.count
    assert_equal i, 2
  end

  def test_statewide_parser_can_tell_if_new_district
    new_hash = {}
    district_record = {:name=>"COLORADO", :third_grade=>{2008=>{:math=>0.697}}}
    district, category, subject, year, data_point = record_data(district_record)
    assert district_new?(new_hash, district)
  end

  def test_statewide_parser_can_tell_if_new_subject
    new_hash = {"COLORADO" => {:name=>"COLORADO", :third_grade=>{2008=>{:math=>0.697}}}}
    district_record = {:name=>"COLORADO", :third_grade=>{2008=>{:reading=>0.703}}}
    district, category, subject, year, data_point = record_data(district_record)
    assert subject_new?(new_hash, district, category, year)
  end

  def test_statewide_parser_can_tell_if_new_year
    new_hash = {"COLORADO" => {:name=>"COLORADO", :third_grade=>{2008=>{:math=>0.697, :reading=>0.703}}}}
    district_record = {:name=>"COLORADO", :third_grade=>{2009=>{:writing=>0.536}}}
    district, category, subject, year, data_point = record_data(district_record)
    assert year_new?(new_hash, district, category, year)
  end

  def test_statewide_parser_can_tell_if_new_category
    new_hash = {"COLORADO" => {:name=>"COLORADO", :third_grade=>{2008=>{:math=>0.697, :reading=>0.703}, 2009=>{:writing=>0.536}}}}
    district_record = {:name=>"COLORADO", :eighth_grade=>{2009=>{:math=>0.499}}}
    district, category, subject, year, data_point = record_data(district_record)
    assert category_new?(new_hash, district, category)
  end

  def test_statewide_parser_can_tell_if_not_new_category
    new_hash = {"COLORADO" => {:name=>"COLORADO", :third_grade=>{2008=>{:math=>0.697, :reading=>0.703}, 2009=>{:writing=>0.536}}}}
    district_record = {:name=>"COLORADO", :third_grade=>{2009=>{:writing=>0.536}}}
    district, category, subject, year, data_point = record_data(district_record)
    refute category_new?(new_hash, district, category)
  end

  def test_statewide_parser_record_data_collect_correct_data
    district_record = {:name=>"COLORADO", :eighth_grade=>{2009=>{:math=>0.499}}}
    assert_equal "COLORADO", district_record[:name]
    assert_equal :eighth_grade, district_record.keys[1]
    assert_equal :math, district_record[district_record.keys[1]].values[0].keys[0]
    assert_equal 2009, district_record[district_record.keys[1]].keys[0]
    assert_equal 0.499, district_record[district_record.keys[1]].values[0].values[0]
    expected = ["COLORADO", :eighth_grade, :math, 2009, 0.499]
    assert_equal expected, record_data(district_record)
  end

  def test_statewide_parser_only_has_one_hash_per_district
    file_tree = {
      :statewide_testing => {
      :third_grade => "./test/test_data/test 3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./test/test_data/test 8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./test/test_data/test Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    assert_equal 18, statewide_test_repo_parser(file_tree).count
  end

  def test_economic_parser_can_parse_lunch_record_data
    district_record = {:free_or_reduced_price_lunch=>{2012=>{:total=>3006}}, :name=>"ACADEMY 20"}
    expected = [:free_or_reduced_price_lunch, 2012, {:total => 3006}, :total, "ACADEMY 20"]
    assert_equal expected, lunch_record_data(district_record)
  end

  def test_economic_parser_can_parse_other_record_data
    district_record = {:title_i=>{2012=>0.01072}, :name=>"ACADEMY 20"}
    expected = [:title_i, 2012, 0.01072, "ACADEMY 20"]
    assert_equal expected, other_record_data(district_record)
  end

  def test_economic_parser_can_tell_if_new_district
    new_hash = {}
    district_record = {:children_in_poverty=>{1997=>0.035}, :name=>"ACADEMY 20"}
    category, year, data_point, district = other_record_data(district_record)
    assert district_new?(new_hash, district)
  end

  def test_economic_parser_can_tell_if_new_year
    new_hash = {"ACADEMY 20" =>{:children_in_poverty=>{1997=>0.035}, :name=>"ACADEMY 20"} }
    district_record = {:children_in_poverty=>{1990=>0.035}, :name=>"ACADEMY 20"}
    category, year, data_point, district = other_record_data(district_record)
    assert year_new?(new_hash, district, category, year)
  end

  def test_economic_parser_can_tell_if_new_category
    new_hash = {"ACADEMY 20" =>{:children_in_poverty=>{1997=>0.035}, :name=>"ACADEMY 20"} }
    district_record = {:title_i=>{2012=>0.01072}, :name=>"ACADEMY 20"}
    category, year, data_point, district = other_record_data(district_record)
    assert category_new?(new_hash, district, category)
  end

  def test_can_economic_parser_can_tell_if_not_new_category
    new_hash = {"ACADEMY 20" =>{:children_in_poverty=>{1997=>0.035}, :name=>"ACADEMY 20"} }
    district_record = {:children_in_poverty=>{1995=>0.032}, :name=>"ACADEMY 20"}
    category, year, data_point, district = other_record_data(district_record)
    refute category_new?(new_hash, district, category)
  end

  def test_economic_parser_can_tell_if_new_type
    new_hash = {"ACADEMY 20" => {:free_or_reduced_price_lunch=>{2012=>{:total=>3006}}, :name=>"ACADEMY 20"}}
    district_record = {:free_or_reduced_price_lunch=>{2012=>{:percentage=>0.0621}}, :name=>"ACADEMY 20"}
    category, year, data_point, type, district = lunch_record_data(district_record)
    assert type_new?(new_hash, district, category, year, type)
  end
end
# new_hash = {"COLORADO" => {:children_in_poverty =>{1998=> 0.036}, :name =>"COLORADO"}}
