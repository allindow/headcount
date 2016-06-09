require_relative 'district_repository'

class HeadcountAnalyst
  include Helper

  attr_reader :dr
  def initialize(dr)
    @dr = dr
  end

  def rate_calculator(location)
    enrollment_data = location.enrollment
    location_percentages = enrollment_data.kindergarten_participation_by_year.values
    location_sum = location_percentages.reduce(0) { |result, num| result += num }
    location_average = location_sum/location_percentages.count
    truncate_float(location_average)
  end

  def kindergarten_participation_rate_variation(district, options)
   first_district = dr.find_by_name(district)
   other_district = dr.find_by_name(options[:against])
   district_participation_rate = rate_calculator(first_district)
   other_district_participation_rate = rate_calculator(other_district)
   variation = district_participation_rate/other_district_participation_rate
   truncate_float(variation)
  end

  def kindergarten_participation_rate_variation_trend(district, options)
    first_district = dr.find_by_name(district)
    other_district = dr.find_by_name(options[:against])
    first_district_percentages = first_district.district_kinder_participation_by_year
    other_district_percentages = other_district.district_kinder_participation_by_year
    trend_calculator(first_district_percentages, other_district_percentages)
  end

  def trend_calculator(first_district_percentages, other_district_percentages)
    nested_year_sets = first_district_percentages.zip(other_district_percentages)
    variation_trend = {}
    nested_year_sets.map do |year_set|
      separated_years_from_data = year_set[0].zip(year_set[1])
      separated_years_from_data[0].uniq!
      year_average = separated_years_from_data[1].inject(:+)/separated_years_from_data[1].count
      year_trend = {separated_years_from_data[0][0] => truncate_float(year_average)}
      variation_trend.merge(year_trend)
    end
  end
end
