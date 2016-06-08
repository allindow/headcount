require 'csv'
require 'pry'
require_relative 'district'

class DistrictRepository

  def initialize(districts = [])
    @districts = districts
  end

  def load_data(file_tree)
    filepath = file_tree.dig(:enrollment, :kindergarten)
    district_data = CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
       @districts << District.new({ :name => row[:location]})
     end
  end

  def find_by_name(name)
    selection = @districts.select do |district_info|
      district_info.name.upcase == name.upcase
    end
    selection.empty? ? nil : selection
  end

  def find_all_matching(fragment)
    @districts.select do |district|
      district.name.downcase.include?(fragment.downcase)
    end
  end

end
