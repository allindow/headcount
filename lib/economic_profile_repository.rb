require_relative 'economic_parser'

class EconomicProfileRepository
  include EconomicParser
  attr_reader :profiles

  def initialize(profiles = [])
    @profiles = profiles
  end

  def load_data(file_tree)
    economic_data = economic_repo_parser(file_tree)
    economic_data.each do |data|
      @profiles << EconomicProfile.new(data)
    end
  end
end
