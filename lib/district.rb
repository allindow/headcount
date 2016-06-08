require 'csv'

class District
  attr_reader   :names

  def initialize(names)
     @names = names
  end

  def name
    names[:name].upcase
  end

end
