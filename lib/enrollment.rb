require 'csv'

class Enrollment
  def initialize(name, kindergarten_participation)
  end
#kindergarten_participation is for 2010, 2011, and 2012 only

  def name
  end

  def kindergarten_participation_by_year
    #returns a hash with years as keys and a truncated three-digit floating point number representing a percentage for all years present in the dataset.
  end

  def kindergarten_participation_in_year(year)
    #A call to this method with any unknown year should return nil.
    #returns truncated three-digit floating point number representing a percentage.
  end

end
