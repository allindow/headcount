require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/district'

class DistrictRepositoryTest < Minitest::Test


  LOAD_FROM_FILE: mock file, load info from mock file (method), when we load, we set @districts to equal an array that somehow* holds all the data we added
    ++

  # INITIALIZE_WITH_DISTRICTS: we need to have the district info from source (manually add, or read from a mock file) before we initialize the repo.
  #   ---
  #
  # LOAD_AT_INITIALIZE: we call the load_data method when we initialize.

  def test_that_load_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
    assert_equal 5, dr.districts.count
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20" , district.name
  end

  def test_find_by_name
    d1 = District.new({:name => "ACADEMY 20"})
    d2 = District.new({:name => "PIZZA 30"})
    dr         = DistrictRepository.new([d1, d2])
    assert_equal "ACADEMY 20", district.name
    assert_nil dr.find_by_name("WHAT")
  end

  def test_find_all_matching
    d1 = District.new({:name => "ACADEMY 20"})
    d2 = District.new({:name => "PIZZA 30"})
    d3 = District.new({name: "Horace's school of pizza"})
    dr         = DistrictRepository.new([d1, d2, d3])

    result = dr.find_all_matching ("acadeMy")
  end

  def test_that_search_by_name_returns_district_name
    #upcased
    #downcased
    #mixed case
  end


  def test_that_search_of_wrong_name_returns_nil
  end

  def test_that_searching_by_name_fragment_returns_district_name
    #upcased
    #downcased
    #mixed case

  end

  def test_that_searching_by_wrong_name_fragment_returns_empty_array
  end
end
