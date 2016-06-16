require_relative 'helper'
require 'csv'

module StatewideParser
  include Helper

  def parsed_test_data(tree, path_counter)
    path = tree.values[0].values[path_counter]
    grade_level = tree.values[0].keys[path_counter]
    CSV.foreach(path, headers: true, header_converters: :symbol).map do |row|
      if row.headers.include? :score
        { name: row[:location].upcase, grade_level =>
          {row[:timeframe].to_i => {row[:score].downcase.to_sym =>
            row[:data].to_f}}}
      else
        if row[:race_ethnicity].downcase == "hawaiian/pacific islander"
          row[:race_ethnicity] = "pacific islander"
        end
        { name: row[:location].upcase,
          row[:race_ethnicity].gsub(" ","_").downcase.to_sym =>
          {row[:timeframe].to_i => {tree.values[0].keys[path_counter] =>
            row[:data].to_f}}}
      end
    end
  end

  def statewide_test_repo_parser(tree)
    all = []
    tree.values[0].values.count.times { |n| all << parsed_test_data(tree, n) }
    by_district = group_names(all.flatten)
    new_hash = {}
    by_district.values.map do |ds|
      ds.each do |dr|
        district, cat, subject, yr, data_point = record_data(dr)
        update_new_data(dr, new_hash, district, cat, subject, yr, data_point)
      end
    end
    new_hash.values
  end

  def update_new_data(dr, newh, d, cat, subj, yr, dp)
    newd = {:name => d, cat => {yr => {subj => dp}}}
    newh[d] = newd                      if district_new?(newh, d)
    newh[d][cat][yr][subj] = dp         if subject_new?(newh, d, cat, yr)
    newh[d][cat][yr] = {subj => dp}     if year_new?(newh, d, cat, yr)
    newh[d][cat] = {yr => {subj => dp}} if category_new?(newh, d, cat)
    newh
  end

  def district_new?(new_hash, district)
    new_hash[district].nil?
  end

  def subject_new?(new_hash, district, category, year)
    new_hash.key?(district) && new_hash[district].key?(category)\
    && new_hash[district][category].key?(year)
  end

  def year_new?(new_hash, district, category, year)
    new_hash.key?(district) && new_hash[district].key?(category)\
    && new_hash[district][category].key?(year) == false
  end

  def category_new?(new_hash, district, category)
    new_hash.key?(district) && new_hash[district].key?(category) == false
  end

  def record_data(dr)
    [dr[:name],
     dr.keys[1],
     dr[dr.keys[1]].values[0].keys[0],
     dr[dr.keys[1]].keys[0],
     truncate_float(dr[dr.keys[1]].values[0].values[0])]
  end

end
