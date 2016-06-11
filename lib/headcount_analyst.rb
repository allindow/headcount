require_relative 'district_repository'

class HeadcountAnalyst
  include Helper
  attr_reader :dr

  def initialize(dr)
    @dr = dr
  end

  def rate_calculator(location, grade_level)
    enrollment_data = location.enrollment
      if grade_level == :kindergarten
        location_percentages = enrollment_data.kindergarten_participation_by_year.values
      elsif grade_level == :high_school_graduation
        location_percentages = enrollment_data.graduation_rate_by_year.values
      end
    location_sum = location_percentages.reduce(0) { |result, num| result += num }
    location_average = location_sum/location_percentages.count
    truncate_float(location_average)
  end

  def kindergarten_participation_rate_variation(district, options = {:against => "Colorado"})
   first_district = dr.find_by_name(district)
   other_district = dr.find_by_name(options[:against])
   variation = rate_calculator(first_district, :kindergarten)/rate_calculator(other_district, :kindergarten)
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


  def graduation_variation(district, options = {:against => "Colorado"})
    first_district = dr.find_by_name(district)
    other_district = dr.find_by_name(options[:against])
    variation = rate_calculator(first_district, :high_school_graduation)/rate_calculator(other_district, :high_school_graduation)
    truncate_float(variation)
  end


  def kindergarten_participation_against_high_school_graduation(district)
    if dr.grade_level_exist?(district, :high_school_graduation) && dr.grade_level_exist?(district, :kindergarten_participation)
        if graduation_variation(district) == 0
          0.0
        else
       truncate_float(kindergarten_participation_rate_variation(district)/graduation_variation(district))
     end
  else
    nil
    end
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options, district = district)
      if options[:for] == "STATEWIDE"
        all_kinder_hs_comparisons(dr)
      elsif options.keys.include?(:across)
        all_correlations = options[:across].map do |district|
          percentage = kindergarten_participation_against_high_school_graduation(district)
          percentage.between?(0.6, 1.5)
        end
        positive_correlation?(all_correlations)
      else
        percentage = kindergarten_participation_against_high_school_graduation(options[:for])
        percentage.between?(0.6, 1.5)
      end
  end

    def all_kinder_hs_comparisons(dr)
      all_correlations = []
      dr.districts.map do |district|
      if district.name.upcase == 'COLORADO'
        all_correlations << nil
      elsif kindergarten_participation_against_high_school_graduation(district.name).nil?
        all_correlations << nil
      else
      all_correlations  << kindergarten_participation_against_high_school_graduation(district.name).between?(0.6,1.5)
      end
    end
      positive_correlation?(all_correlations)

    end

  def positive_correlation?(all_correlations)
     positive_correlation = all_correlations.count(true).to_f/all_correlations.count.to_f
    positive_correlation > 0.7
  end
end
