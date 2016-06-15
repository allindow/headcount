require_relative 'statewide_test'
require_relative 'statewide_parser'

class EconomicProfile
  include Helper
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end


end
