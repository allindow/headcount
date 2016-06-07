require 'minitest/autorun'
require 'minitest/pride'
require 'district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_that_load_data_returns_a_hash
  end

  def test_that_there_is_only_one_of_each_district
    #could use #one? method asserting true
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
