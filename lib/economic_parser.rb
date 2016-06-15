require_relative 'helper'

module EconomicParser
  include Helper

  def parsed_repo_data(file_tree, path_counter)
    # filepath = file_tree.values[0].values[path_counter]
    # CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
    #   if
    # end
    # # {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    # #     :children_in_poverty => {2012 => 0.1845},
    # #     :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    # #     :title_i => {2015 => 0.543},
    # #     :name => "ACADEMY 20"
    # #    }
  end

  def economic_repo_parser(file_tree)
    path_counter = 0
    all_data = []
    i = file_tree.values[0].values.count
    i.times do
      all_data << parsed_repo_data(file_tree, path_counter)
    end
  end

end
