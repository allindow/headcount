require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require 'rake/testtask'

class EnrollmentRepositoryTest < Minitest::Test

  def test_can_return_enrollment_object_by_name
    enrollment1 = Enrollment.new({:name => "ACADEMY 20"})
    enrollment2 = Enrollment.new({:name => "Pizza academy 30"})
    er          = EnrollmentRepository.new([enrollment1, enrollment2])
    assert_equal enrollment1, er.find_by_name("acadeMy 20")
    assert_equal enrollment2, er.find_by_name("pizza ACADEMY 30")
  end

  def test_that_it_returns_nil
    enrollment1 = Enrollment.new({:name => "ACADEMY 20"})
    enrollment2 = Enrollment.new({:name => "Pizza academy 30"})
    er          = EnrollmentRepository.new([enrollment1, enrollment2])
    assert_nil(er.find_by_name("ACADEMY Pizza"))
  end

  def test_loading_enrollments
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/test_data/test_kinder_full_day.csv"
      }
      })
      enrollment = er.find_by_name("ACADEMY 20")
      assert_equal "ACADEMY 20", enrollment.name
    end

  def test_can_get_enrollment_data_from_high_school_graduation_data
    skip
    er = EnrollmentRepository.new
    er.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"
        }
        })
        enrollment = er.find_by_name("ACADEMY 20")
        assert enrollment.attributes.keys.include? :high_school_graduation
  end
end
