require_relative 'helper'

class StatewideTest
  attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def name
      @attributes[:name]
    end
end
