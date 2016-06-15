class UnknownDataError < StandardError
  attr_reader :msg
  def initialize(msg = "UnknownDataError")
    @msg = msg
  end
end

class UnknownRaceError < StandardError
end
