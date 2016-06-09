require 'csv'
require_relative 'district'
require_relative 'csv_parser'
require_relative 'enrollment_repository'
require_relative 'enrollment'


class DistrictRepository
    include CSVParser
attr_reader :districts

  def initialize(districts = [])
    @districts = districts
    @enrollment_repo = []
  end


  def load_data(file_tree)
    er = EnrollmentRepository.new
    er.load_data(file_tree)
    @enrollment_repo << er
    district_names = district_repo_parser(file_tree)
    district_names.each do |name|
      d = District.new(name)
      d.enrollment = er.find_by_name(name)
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

end
