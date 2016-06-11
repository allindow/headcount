require 'csv'

class District
  attr_reader   :name
  attr_accessor :enrollment

  def initialize(name)
     @name = name[:name].upcase
     @enrollment = enrollment
  end

  def district_kinder_participation_by_year
    enrollment.kindergarten_participation_by_year
  end

  def district_graduation_rate_by_year
    enrollment.graduation_rate_by_year
  end

end
