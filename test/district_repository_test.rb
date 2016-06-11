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
end
