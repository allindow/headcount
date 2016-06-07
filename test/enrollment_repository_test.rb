require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require 'pry'

class EnrollmentRepositoryTest < Minitest::Test

  def test_loading_enrollments
    er= EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
    enrollment = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", enrollment.name
  end

  def test_that_enrollment_instantiates_with_instance_of_enrollment
    enrollment1 = Enrollment.new({:name => "ACADEMY 20"})
    enrollment2 = Enrollment.new({:name => "Pizza academy 30"})
    er          = EnrollmentRepository.new([enrollment1, enrollment2])
    assert_equal enrollment1, er.find_by_name("acadeMy 20")
    assert_equal enrollment2, er.find_by_name("pizza ACADEMY 30")
    # assert_equal "Pizza academy 30", enrollment.name

  end

end
