
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
