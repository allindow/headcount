require 'csv'
require 'pry'
require './lib/district'
require './lib/csv_parser'

class DistrictRepository
    include CSVParser

  def initialize(districts = [])
    @districts = districts
  end

  def load_data(file_tree)
    district_names = district_repo_parser(file_tree)
    district_names.each do |name|
     @districts << District.new(name)
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
