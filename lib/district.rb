require 'csv'
#we'll probably need to compare a few data files to capture the full range of district names
#we'll need a method that takes in the location header and deletes any repeats of that name

###QUESTIONS###
#1) should we focus just on enrollment csv files or look at all of them?  (statewide testing would have the same data probably, and socioeconomic status seems like it'd be less reliable)


class District
  attr_reader   :names

  def initialize(names)
     @names = names
  end

  def name
    names[:name].upcase
  end

end
