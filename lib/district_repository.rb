require 'csv'
require_relative 'district'
require_relative 'csv_parser'
require_relative 'enrollment_repository'
require_relative 'enrollment'
require_relative 'statewide_test'
require_relative 'statewide_test_repository'

class DistrictRepository
  include CSVParser
  attr_reader :districts

  def initialize(districts = [])
    @districts = districts
    @str = StatewideTestRepository.new
    @er = EnrollmentRepository.new
  end

  def er_tree(file_tree)
    er_tree = {}
    er_tree[:enrollment] = file_tree[:enrollment]
    er_tree
  end

  def str_tree(file_tree)
    str_tree = {}
    str_tree[:statewide_testing] = file_tree[:statewide_testing]
    str_tree
  end


  def file_tree_paths(file_tree)
    if file_tree[:enrollment]
      @er.load_data(er_tree(file_tree))
    end
    if file_tree[:statewide_testing]
      @str.load_data(str_tree(file_tree))
    end
  end

  def load_data(file_tree)
    file_tree_paths(file_tree)
    district_names = district_repo_parser(file_tree)
    district_names.each do |name|
      d = District.new(name)
      d.enrollment = @er.find_by_name(name) if file_tree[:enrollment]
      d.statewide_test = @str.find_by_name(name) if file_tree[:statewide_testing]
      @districts << d
   end
 end

  def find_by_name(name)
    selection = @districts.select do |district_info|
      district_info.name.upcase == name.upcase
    end
    selection.empty? ? nil : selection[0]
  end

  def find_all_matching(fragment)
    @districts.select do |district|
      district.name.downcase.include?(fragment.downcase)
    end
  end

  def grade_level_exist?(district, grade_level)
    find_by_name(district).enrollment.attributes.key? (grade_level)
  end
end
