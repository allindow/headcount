require 'csv'
require_relative 'statewide_test'
require_relative 'csv_parser'

class StatewideTestRepository
  include CSVParser
  attr_reader     :statewide_testing

  def initialize(statewide_testing = [])
    @statewide_testing = statewide_testing
  end

  def load_data(file_tree)
    statewide_data = statewide_test_repo_parser(file_tree)
    statewide_data.each do |data|
      @statewide_testing << StatewideTest.new(data)
    end
  end

  def find_by_name(name)
    selection = @statewide_testing.select do |data_set|
      if name.is_a? Hash
      data_set.name.upcase == name[:name].upcase
    else
      data_set.name.upcase == name.upcase
    end
  end
    selection.empty? ? nil : selection[0]
  end


end
