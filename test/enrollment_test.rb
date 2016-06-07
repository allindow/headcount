
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'


class EnrollmentTest < Minitest::Test

  def test_find_name_of_enrollment_object
    e = Enrollment.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", e.name
  end

  def test_kindergarten_participation
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    result = { 2010 => 0.391,
     2011 => 0.353,
     2012 => 0.267,
   }
    assert_equal result, e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_by_specific_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    result = { 2010 => 0.391,
     2011 => 0.353,
     2012 => 0.267,
   }
    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

  def test_truncates_float
    e = Enrollment.new({})
    assert_equal 1.23, e.truncate_float(1.23)
  end



end
