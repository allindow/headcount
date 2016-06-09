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
   correct_district = dr.find_by_name(district)
   divisor = dr.find_by_name(options[:against])
   district_participation_rate = rate_calculator(correct_district)
   divisor_participation_rate = rate_calculator(divisor)
   variation = district_participation_rate/divisor_participation_rate
   truncate_float(variation)
  end


  def kindergarten_participation_rate_variation_trend(district, options)
    correct_district = dr.find_by_name(district)
    divisor = dr.find_by_name(options[:against])
    enrollment_data = correct_district.enrollment
    correct_district_percentages = enrollment_data.kindergarten_participation_by_year
    divisor_enrollment_data = divisor.enrollment
    divisor_percentages = divisor_enrollment_data.kindergarten_participation_by_year
    nested_year_sets = correct_district_percentages.zip(divisor_percentages)
    variation_trend = {}
    nested_year_sets.map do |year_set|
      separated_data = year_set[0].zip(year_set[1])
      separated_data[0].uniq!
      year_average = separated_data[1].inject(:+)/separated_data[1].count
      year_trend = {separated_data[0][0] => truncate_float(year_average)}
      variation_trend.merge(year_trend)
    end
  end
end
