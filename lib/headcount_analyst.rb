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

  def kindergarten_participation_correlates_with_high_school_graduation(options)
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

  def statewide_lunch_average
    district = dr.find_by_name("colorado")
    sum = district.economic_profile.attributes[:free_or_reduced_price_lunch].values.map do |set|
          set[:total]
        end.inject(:+)
    count = district.economic_profile.attributes[:free_or_reduced_price_lunch].values.count
    all = sum/count
    truncate_float(all/dr.districts.length)
  end

  def statewide_children_in_poverty_average
    total = 0
    valid_districts = 0
    dr.districts.each do |district|
      if district.economic_profile.attributes[:children_in_poverty]
        total_percentages = district.economic_profile.attributes[:children_in_poverty].values.inject(:+)
        total_years = district.economic_profile.attributes[:children_in_poverty].values.count
        total += total_percentages/total_years
        valid_districts += 1
      end
    end
    truncate_float(total/valid_districts)
  end

  def statewide_median_household_income
    district = dr.find_by_name("colorado")
    sum = district.economic_profile.attributes[:median_household_income].values.inject(:+)
    count = district.economic_profile.attributes[:median_household_income].values.count
    truncate_float(sum/count)
  end

  def statewide_hs_grad_average
    district = dr.find_by_name("colorado")
    sum = district.enrollment.attributes[:high_school_graduation].values.inject(:+)
    count = district.enrollment.attributes[:high_school_graduation].values.count
    truncate_float(sum/count)
  end

  def children_in_poverty_average(district)
      sum = district.economic_profile.attributes[:children_in_poverty].values.inject(:+)
      count = district.economic_profile.attributes[:children_in_poverty].values.count
      truncate_float(sum/count)
  end

  def hs_grad_average(district)
    sum = district.enrollment.attributes[:high_school_graduation].values.inject(:+)
    count = district.enrollment.attributes[:high_school_graduation].values.count
    truncate_float(sum/count)
  end

  def lunch_average(district)
    sum = district.economic_profile.attributes[:free_or_reduced_price_lunch].values.map do |set|
          set[:total]
        end.inject(:+)
    count = district.economic_profile.attributes[:free_or_reduced_price_lunch].values.count
    sum/count
  end

  def median_income(district)
    sum = district.economic_profile.attributes[:median_household_income].values.inject(:+)
    count = district.economic_profile.attributes[:median_household_income].values.count
    sum/count
  end

  def statewide_lunch_poverty_grad
    {:free_and_reduced_price_lunch_rate => statewide_lunch_average,
      :children_in_poverty_rate => statewide_children_in_poverty_average,
      :high_school_graduation_rate => statewide_hs_grad_average}
  end

  def statewide_income_poverty
    {:median_household_income => statewide_median_household_income,
      :children_in_poverty_rate => statewide_children_in_poverty_average}
  end

  def includes_grad_lunch_poverty?(district)
    district.economic_profile.attributes[:free_or_reduced_price_lunch] &&
    district.enrollment.attributes[:high_school_graduation] &&
    district.economic_profile.attributes[:children_in_poverty] &&
    district.name != "COLORADO"
  end

  def includes_income_and_poverty?(district)
    district.economic_profile.attributes[:median_household_income] &&
    district.economic_profile.attributes[:children_in_poverty] &&
    district.name != "COLORADO"
  end

  def higher_than_statewide_income_poverty?(district)
    median_income(district) > statewide_median_household_income &&
    children_in_poverty_average(district) > statewide_children_in_poverty_average
  end

  def higher_than_statewide_in_poverty_lunch_grad?(district)
    lunch_average(district) > statewide_lunch_average &&
    children_in_poverty_average(district) > statewide_children_in_poverty_average &&
    hs_grad_average(district) > statewide_hs_grad_average
  end

  def lpg_new_result_entry(district)
    {:free_and_reduced_price_lunch_rate => lunch_average(district),
    :children_in_poverty_rate => children_in_poverty_average(district),
    :high_school_graduation_rate => hs_grad_average(district)}
  end

  def pi_new_result_entry(district)
    {:median_household_income => median_income(district),
     :children_in_poverty_rate => children_in_poverty_average(district)}
  end

  def high_poverty_and_high_school_graduation
    matching = []
    dr.districts.map do |district|
        if includes_grad_lunch_poverty?(district) &&
        higher_than_statewide_in_poverty_lunch_grad?(district)
          matching << ResultEntry.new(lpg_new_result_entry(district))
        end
    end
    ResultSet.new(matching_districts: matching, statewide_average: ResultEntry.new(statewide_lunch_poverty_grad))
  end

  def high_income_and_poverty
    matching = []
    dr.districts.map do |district|
        if includes_income_and_poverty?(district) &&
        higher_than_statewide_income_poverty?(district)
          matching << ResultEntry.new(pi_new_result_entry(district))
        end
    end
    ResultSet.new(matching_districts: matching, statewide_average: ResultEntry.new(statewide_income_poverty))
  end
end
