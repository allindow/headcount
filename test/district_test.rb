require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'
require 'rake/testtask'
require './lib/district_repository'


class DistrictTest < Minitest::Test

def test_name_returns_upcase_string_name_of_district
  d = District.new({:name => "Academy 20"})
  assert_equal "ACADEMY 20", d.name
end

def test_can_get_enrollments_kinder_participation_by_year
  dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
      :kindergarten => "./test/test_data/test_kinder_full_day.csv"
      }
    })
  district = dr.find_by_name("academy 20")
  expected = {2010=>0.436, 2008=>0.384}
  assert_equal expected, district.district_kinder_participation_by_year
end

def test_can_get_enrollments_graduation_rate_by_year
  dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv",
    }
    })
  expected = {2010=>0.895, 2011=>0.895, 2012=>0.889, 2013=>0.913, 2014=>0.898}
  district = dr.find_by_name("academy 20")
  assert_equal expected, district.district_graduation_rate_by_year
end

end
