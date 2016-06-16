require_relative 'helper'
require 'csv'

module EconomicParser
  include Helper

  def lunch_percent_formatting(row)
    { :free_or_reduced_price_lunch  =>
      {row[:timeframe].to_i => {:percentage => row[:data].to_f}},
      :name => row[:location].upcase }
  end

  def lunch_percent?(row)
    row[:poverty_level] == "Eligible for Free or Reduced Lunch"\
    && row[:dataformat] == "Percent"
  end

  def lunch_number_formatting(row)
    { :free_or_reduced_price_lunch =>
      {row[:timeframe].to_i => {:total => row[:data].to_i}},
      :name => row[:location].upcase }
  end

  def lunch_number?(row)
    row[:poverty_level] == "Eligible for Free or Reduced Lunch"\
    && row[:dataformat] == "Number"
  end


  def chil_in_pov?(file_tree,filepath, row)
    file_tree.values[0].key(filepath) == :children_in_poverty &&
    row[:dataformat] == "Percent"
  end

  def children_poverty_formatting(row)
    { :children_in_poverty => {row[:timeframe].to_i =>
      row[:data].to_f},:name => row[:location].upcase }
  end

  def title_i?(file_tree, filepath, row)
    file_tree.values[0].key(filepath) == :title_i
  end

  def title_i_formatting(row)
    { :title_i => {row[:timeframe].to_i => row[:data].to_f},
    :name => row[:location].upcase }
  end

  def median_household_formatting(row)
    timeframe = row[:timeframe].split("-").map { |num| num.to_i }
    { :median_household_income => {timeframe => row[:data].to_i},
    :name => row[:location].upcase }
  end

  def household?(file_tree, filepath, row)
    file_tree.values[0].key(filepath) == :median_household_income
  end

  def parsed_economic_data(tree, path_counter)
    array = []
    path = tree.values[0].values[path_counter]
    CSV.foreach(path, headers: true, header_converters: :symbol).each do |row|
      array << lunch_percent_formatting(row)   if lunch_percent?(row)
      array << lunch_number_formatting(row)    if lunch_number?(row)
      array << children_poverty_formatting(row)if chil_in_pov?(tree,path,row)
      array << title_i_formatting(row)         if title_i?(tree,path,row)
      array << median_household_formatting(row)if household?(tree,path,row)
    end
    array
  end

  def economic_repo_parser(file_tree)
    all_data = []
    file_tree.values[0].values.count.times do |n|
      all_data << parsed_economic_data(file_tree, n)
    end
    by_district = group_names(all_data.flatten)
    new_hash = {}
    by_district.values.map do |district_set|
      district_set.each do |district_record|
        update_new_economic_data(district_record, new_hash)
      end
    end
    new_hash.values
  end

  def update_new_economic_data(district_record, new_hash)
    cat = district_record.keys[0]
    if cat == :free_or_reduced_price_lunch
      lunch_parser(new_hash, district_record)
    else
      other_cat_parser(new_hash, district_record)
    end
    new_hash
  end

  def lunch_record_data(district_record)
    [district_record.keys[0], district_record.values[0].keys[0],
    district_record.values[0].values[0],
    district_record.values[0].values[0].keys[0], district_record[:name]]
  end

  def lunch_parser(newh, dr)
    cat, yr, dp, tp, d = lunch_record_data(dr)
    new_district = {cat => {yr => dp}, :name => d}
    newh[d] = new_district                   if district_new?(newh, d)
    newh[d][cat][yr] = dp                    if yr_new?(newh, d, cat, yr)
    newh[d][cat] = {yr => dp}                if cat_new?(newh, d, cat)
    newh[d][cat][yr][tp] = dr[cat][yr][tp]   if type_new?(newh, d, cat, yr, tp)
  end

  def other_cat_parser(newh, dr)
    cat, year, dp, district = other_record_data(dr)
    new_district = { cat => {year => dp}, :name => district}
    newh[district] = new_district      if district_new?(newh, district)
    newh[district][cat][year] = dp     if yr_new?(newh, district, cat, year)
    newh[district][cat] = {year => dp} if cat_new?(newh, district, cat)
  end

  def other_record_data(district_record)
    [district_record.keys[0], district_record.values[0].keys[0],
    district_record.values[0].values[0], district_record[:name]]
  end

  def district_new?(new_hash, district)
    new_hash[district].nil?
  end

  def yr_new?(new_hash, district, cat, year)
    new_hash.key?(district) && new_hash[district].key?(cat) &&
    new_hash[district][cat].key?(year) == false
  end

  def cat_new?(new_hash, district, cat)
    new_hash.key?(district) && new_hash[district].key?(cat) == false
  end

  def type_new?(new_hash, district, cat, year, type)
    new_hash.key?(district) && new_hash[district].key?(cat) &&
    new_hash[district][cat].key?(year) &&
    new_hash[district][cat][year].key?(type) == false
  end

end
