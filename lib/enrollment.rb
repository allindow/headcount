require 'pry'

class Enrollment
  def initialize(attributes)
    @attributes = attributes
  end

  def kindergarten_participation_by_year
    @attributes[:kindergarten_participation].reduce({}) do |result, pair|
    result.merge({pair.first => truncate_float(pair.last)})
  end
end

  def kindergarten_participation_in_year(year)
    # truncate_float(@attributes[:kindergarten_participation][year])
    kindergarten_participation_by_year[year]
  end


  def truncate_float(float)
    #might need to live in a module later on
    (float * 1000).floor / 1000.to_f
  end

def name
  @attributes[:name]
end

end
#   def kindergarten_participation_by_year
  #returns a hash with years as keys and a truncated three-digit floating point number representing a percentage for all years present in the dataset
#
#   def kindergarten_participation_in_year(year)
#     #A call to this method with any unknown year should return nil.
#     #returns truncated three-digit floating point number representing a percentage.
#   end
#
# end
