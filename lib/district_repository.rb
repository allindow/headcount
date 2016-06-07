require 'csv'


###QUESTIONS###
#2) are we writing these methods to another file? e.g. load_data pulls in enrollment and district name. should it be stored in its own file?
#3) re: load_data, should we anticipate needing to pull in other grades/csv files?


class DistrictRepository

  def initialize
    @districts = districts
  end

  def load_data(hash with enrollment and kindergarten )
    read file, (holds data about districts), parse through it (read line by line, each line represents diff district)
      info = "Adams County, 874547, 2015, 15"
    store it somehow...
      store in a class (District)
      District.new({name: info.split(",")[0]})
    stores those district objects in a new structure @districts
  end

  def find_by_name
    districts.find do |name|
      district.name == name
    end
  end

  def find_all_matching(fragment)
    @districts.select do |district|
      district.name.downcase.include?(fragment.downcase)
    end
  end

end
