require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'

class DistrictTest < Minitest::Test

def test_name_returns_upcase_string_name_of_district
  d = District.new({:name => "Academy 20"})
  assert_equal "ACADEMY 20", d.name
end



end
