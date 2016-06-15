require_relative 'economic_parser'
require_relative 'economic_profile'

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

    def find_by_name(name)
      selection = @profiles.select do |data_set|
        data_set.attributes[:name].upcase == name.upcase
      end
      selection.empty? ? nil : selection[0]
    end

end
