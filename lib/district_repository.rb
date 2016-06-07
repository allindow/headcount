require 'csv'


###QUESTIONS###
#2) are we writing these methods to another file? e.g. load_data pulls in enrollment and district name. should it be stored in its own file?
#3) re: load_data, should we anticipate needing to pull in other grades/csv files?


class DistrictRepository
    #include modulename
  #holds District instances (District.new) so need to pull in district data from the data files
  def initialize
  
  end

  def load_data
    #returns a hash of :enrollment and :kindergarten(which is tied to the string of csv file)

  end

  def find_by_name
    #finds a district by name and returns the District object(?)
    #returns either nil or an instance of District having done a case insensitive search
  end

  def find_all_matching
    # returns either [] or one or more matches which contain the supplied name fragment, case insensitive
    #could use method #contains?
  end

end














# for reference, here are the enrollment files:
#Dropout rate information
#Kindergarten enrollment rates
#Online enrollment rates
#Overall enrollment rates
#Enrollment rates by race and ethnicity
#High school graduation rates by race and ethnicity
#Special education enrollment rates'
