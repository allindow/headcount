# require_relative

class ResultEntry
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def free_and_reduced_price_lunch_rate
    attributes[:free_and_reduced_price_lunch_rate]
  end

  def children_in_poverty_rate
    attributes[:children_in_poverty_rate]
  end

  def high_school_graduation_rate
    attributes[:high_school_graduation_rate]
  end

end
