require_relative 'enrollment'
require_relative 'enrollment_parser'

class EnrollmentRepository
  include EnrollmentParser
  attr_reader :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def find_by_name(name)
    selection = @enrollments.select do |data_set|
      if name.is_a? Hash
      data_set.name.upcase == name[:name].upcase
    else
      data_set.name.upcase == name.upcase
    end
  end
    selection.empty? ? nil : selection[0]
  end

  def load_data(file_tree)
    enrollment_names = enrollment_repo_parser(file_tree)
    enrollment_names.each do |name|
    @enrollments << Enrollment.new(name)
    end
  end
end
