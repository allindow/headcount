require_relative 'helper'

class Enrollment
  include Helper

attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def name
    @attributes[:name]
  end

  def kindergarten_participation_by_year
      @attributes[:kindergarten_participation].reduce({}) do |result, pair|
      result.merge({pair.first => truncate_float(pair.last)})
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end


end
