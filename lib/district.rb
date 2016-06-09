require 'csv'

class District
  attr_reader   :name
  attr_accessor :enrollment


  def initialize(name)
     @name = name[:name].upcase
     @enrollment = enrollment
  end

end
