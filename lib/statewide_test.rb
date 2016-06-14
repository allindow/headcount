require_relative 'helper'

class StatewideTest
  attr_reader :attributes,
              :parameter

    def initialize(attributes)
      @attributes = attributes
      @parameter = {3 => :third_grade, 8 => :eighth_grade}
    end

    def name
      @attributes[:name]
    end

    def proficient_by_grade(grade)
      self.attributes[parameter[grade]]
    end
end
