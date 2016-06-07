require 'csv'
#we'll probably need to compare a few data files to capture the full range of district names
#we'll need a method that takes in the location header and deletes any repeats of that name

###QUESTIONS###
#1) should we focus just on enrollment csv files or look at all of them?  (statewide testing would have the same data probably, and socioeconomic status seems like it'd be less reliable)

  #contents = CSV.open 'which file we're using.csv', headers: true, header_converters: :symbol

class District
  def initialize(name)
    #uses symbol :name
  end
#Location,TimeFrame,DataFormat,Data
  def read_files
      contents.each do |row|
      index = row[0]
      name = row[:location]
      zipcode = clean_zipcode(row[:zipcode])
  def name
    #name.upcase - returns the upcased string name of the district
  end

end
