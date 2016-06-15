require_relative 'helper'
require 'csv'

module EconomicParser
  include Helper

    def lunch_percent_formatting(row)
      { :free_or_reduced_price_lunch  => {row[:timeframe].to_i => {:percentage => row[:data].to_f}}, :name => row[:location].upcase }
    end

    def lunch_percent?(row)
      row[:poverty_level] == "Eligible for Free or Reduced Lunch" && row[:dataformat] == "Percent"
    end

    def lunch_number_formatting(row)
      { :free_or_reduced_price_lunch => {row[:timeframe].to_i => {:total => row[:data].to_i}}, :name => row[:location].upcase }
    end

    def lunch_number?(row)
      row[:poverty_level] == "Eligible for Free or Reduced Lunch" && row[:dataformat] == "Number"
    end


    def children_in_poverty?(file_tree,filepath, row)
      file_tree.values[0].key(filepath) == :children_in_poverty
    end

    def children_poverty_formatting(row)
      { :children_in_poverty => {row[:timeframe].to_i => row[:data].to_f},:name => row[:location].upcase }
    end

    def title_i?(file_tree, filepath, row)
      file_tree.values[0].key(filepath) == :title_i
    end

    def title_i_formatting(row)
      { :title_i => {row[:timeframe].to_i => row[:data].to_f}, :name => row[:location].upcase }
    end

    def median_household_formatting(row)
      timeframe = row[:timeframe].split("-").map { |num| num.to_i }
      { :median_household_income => {timeframe => row[:data].to_i}, :name => row[:location].upcase }
    end

    def household?(file_tree, filepath, row)
      file_tree.values[0].key(filepath) == :median_household_income
    end

    def parsed_economic_data(file_tree, path_counter)
      array = []
      filepath = file_tree.values[0].values[path_counter]
      CSV.foreach(filepath, headers: true, header_converters: :symbol).each do |row|
        array << lunch_percent_formatting(row)      if lunch_percent?(row)
        array << lunch_number_formatting(row)       if lunch_number?(row)
        array << children_poverty_formatting(row)   if children_in_poverty?(file_tree,filepath,row)
        array << title_i_formatting(row)            if title_i?(file_tree,filepath,row)
        array << median_household_formatting(row)   if household?(file_tree,filepath,row)
      end
      array
    end

    def economic_repo_parser(file_tree)
      all_data = []
      file_tree.values[0].values.count.times { |n| all_data << parsed_economic_data(file_tree, n) }
      by_district = group_names(all_data.flatten)
      new_hash = {}
      by_district.values.map do |district_set|
        district_set.each do |district_record|
          require "pry"; binding.pry
        end
      end
  end

    def update_new_data(district_record, new_hash)
      category = district_record.keys[0]
      if category == :free_or_reduced_price_lunch
        lunch_parser(new_hash, district_record)
      else
        other_category_parser(new_hash, district_record)
      end
      new_hash
    end
    def lunch_record_data(district_record)
      [district_record.keys[0], district_record.values[0].keys[0],
      district_record.values[0].values[0],
      district_record.values[0].values[0].keys[0], district_record[:name]]
    end

  def lunch_parser(new_hash, district_record)
    category, year, data_point, type, district = lunch_record_data(district_record)
    new_district = { category => {year => {type => data_point}}, :name => district}
    new_hash[district] = new_district                     if district_new?(new_hash, district)
    new_hash[district][category][year] = data_point       if year_new?(new_hash, district, category, year)
    new_hash[district][category] = {year => data_point}   if category_new?(new_hash, district, category)
    new_hash[district][category][year][type] = new_record[category][year][type]   if type_new?(new_hash, district, category, year, type)
  end

  def other_category_parser(new_hash, district_record)
    category, year, data_point, district = other_record_data(district_record)
    new_district = { category => {year => data_point}, :name => district}
    new_hash[district] = new_district                     if district_new?(new_hash, district)
    new_hash[district][category][year] = data_point       if year_new?(new_hash, district, category, year)
    new_hash[district][category] = {year => data_point}   if category_new?(new_hash, district, category)
  end

  def other_record_data(district_record)
    [district_record.keys[0], district_record.values[0].keys[0],
    district_record.values[0].values[0], district_record[:name]]
  end

  def district_new?(new_hash, district)
    new_hash[district].nil?
  end

  def year_new?(new_hash, district, category, year)
    new_hash.key?(district) && new_hash[district].key?(category) && new_hash[district][category].key?(year) == false
  end

  def category_new?(new_hash, district, category)
    new_hash.key?(district) && new_hash[district].key?(category) == false
  end

  def type_new?(new_hash, district, category, year, type)
    new_hash.key?(district) && new_hash[district].key?(category) &&
    new_hash[district][category].key?(year) &&
    new_hash[district][category][year].key?(type) == false
  end
end
