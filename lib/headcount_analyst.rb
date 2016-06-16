require_relative 'district_repository'

class HeadcountAnalyst
  include Helper
  attr_reader :dr

  def initialize(dr)
    @dr = dr
  end

  def rate_calc(location, grade_level)
    enrollment_data = location.enrollment
      if grade_level == :kindergarten
        loc_perc = enrollment_data.kindergarten_participation_by_year.values
      elsif grade_level == :high_school_graduation
        loc_perc = enrollment_data.graduation_rate_by_year.values
      end
    location_sum = loc_perc.reduce(0) { |result, num| result += num }
    location_average = location_sum/loc_perc.count
    truncate_float(location_average)
  end

  def kindergarten_participation_rate_variation(d,options={against: "Colorado"})
   d1 = dr.find_by_name(d)
   d2 = dr.find_by_name(options[:against])
   variation = rate_calc(d1, :kindergarten)/rate_calc(d2, :kindergarten)
   truncate_float(variation)
  end

  def kindergarten_participation_rate_variation_trend(district, options)
    d1 = dr.find_by_name(district)
    d2 = dr.find_by_name(options[:against])
    d1_percentages = d1.district_kinder_participation_by_year
    d2_percentages = d2.district_kinder_participation_by_year
    trend_calculator(d1_percentages, d2_percentages)
  end

  def trend_calculator(d1_percentages, d2_percentages)
    nested_year_sets = d1_percentages.zip(d2_percentages)
    variation_trend = {}
    nested_year_sets.map do |year_set|
      yrs_from_data = year_set[0].zip(year_set[1])
      yrs_from_data[0].uniq!
      year_average = yrs_from_data[1].inject(:+)/yrs_from_data[1].count
      year_trend = {yrs_from_data[0][0] => truncate_float(year_average)}
      variation_trend.merge(year_trend)
    end
  end


  def graduation_variation(district, options = {:against => "Colorado"})
    d1 = dr.find_by_name(district)
    d2 = dr.find_by_name(options[:against])
    d1_rate = rate_calc(d1, :high_school_graduation)
    d2_rate = rate_calc(d2, :high_school_graduation)
    truncate_float(d1_rate/d2_rate)
  end

  def hs_and_kinder?(district)
    dr.grade_level_exist?(district, :high_school_graduation) &&
    dr.grade_level_exist?(district, :kindergarten_participation)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    if hs_and_kinder?(district)
        if graduation_variation(district) == 0
          0.0
        else
          kinder_vari = kindergarten_participation_rate_variation(district)
          grad_vari   = graduation_variation(district)
          truncate_float(kinder_vari/grad_vari)
        end
    else
      nil
    end
  end

  def kindergarten_participation_correlates_with_high_school_graduation(opt)
      if opt[:for] == "STATEWIDE"
        all_kinder_hs_comparisons(dr)
      elsif opt.keys.include?(:across)
        all_correlations = opt[:across].map do |dist|
          x = kindergarten_participation_against_high_school_graduation(dist)
          x.between?(0.6, 1.5)
        end
        positive_correlation?(all_correlations)
      else
        y = kindergarten_participation_against_high_school_graduation(opt[:for])
        y.between?(0.6, 1.5)
      end
  end

  def all_kinder_hs_comparisons(dr)
    all = []
    dr.districts.map do |d|
      if d.name.upcase == 'COLORADO'
        all << nil
      elsif kindergarten_participation_against_high_school_graduation(d.name)\
        .nil?
        all << nil
      else
        x = kindergarten_participation_against_high_school_graduation(d.name)
        all << x.between?(0.6,1.5)
      end
    end
    positive_correlation?(all)
  end

  def positive_correlation?(all)
     positive_correlation = all.count(true).to_f/all.count.to_f
    positive_correlation > 0.7
  end

  def statewide_lunch_average
    district = dr.find_by_name("colorado")
    d= district.economic_profile.attributes[:free_or_reduced_price_lunch].values
    sum = d.map do |set|
          set[:total]
        end.inject(:+)

    count = d.count
    all = sum/count
    truncate_float(all/dr.districts.length)
  end

  def sw_children_in_poverty_average
    total = 0
    valid_districts = 0
    dr.districts.each do |d|
      if d.economic_profile.attributes[:children_in_poverty]
        x= d.economic_profile.attributes[:children_in_poverty].values.inject(:+)
        y= d.economic_profile.attributes[:children_in_poverty].values.count
        total += x/y
        valid_districts += 1
      end
    end
    truncate_float(total/valid_districts)
  end

  def statewide_median_household_income
    d = dr.find_by_name("colorado")
    x= d.economic_profile.attributes[:median_household_income].values.inject(:+)
    y= d.economic_profile.attributes[:median_household_income].values.count
    truncate_float(x/y)
  end

  def statewide_hs_grad_average
    d     = dr.find_by_name("colorado")
    sum   = d.enrollment.attributes[:high_school_graduation].values.inject(:+)
    count = d.enrollment.attributes[:high_school_graduation].values.count
    truncate_float(sum/count)
  end

  def children_in_poverty_average(d)
    sum = d.economic_profile.attributes[:children_in_poverty].values.inject(:+)
    count = d.economic_profile.attributes[:children_in_poverty].values.count
    truncate_float(sum/count)
  end

  def hs_grad_average(d)
    sum    = d.enrollment.attributes[:high_school_graduation].values.inject(:+)
    count  = d.enrollment.attributes[:high_school_graduation].values.count
    truncate_float(sum/count)
  end

  def lunch_average(d)
    lunch = d.economic_profile.attributes[:free_or_reduced_price_lunch].values
    sum   = lunch.map do |set|
          set[:total]
        end.inject(:+)
    count = lunch.count
    sum/count
  end

  def median_income(d)
    income = d.economic_profile.attributes[:median_household_income].values
    sum    = income.inject(:+)
    count  = income.count
    sum/count
  end

  def income_variation(district)
    median_income(district)/statewide_median_household_income
  end

  def kinder_rate_variation(d, options = {:against => "Colorado"})
   d2 = dr.find_by_name(options[:against])
   variation = rate_calc(d, :kindergarten)/rate_calc(d2, :kindergarten)
   truncate_float(variation)
  end

  def kindergarten_participation_against_household_income(dist)
    if income_variation(dist) == 0.0
      return 0.0
    else
      truncate_float(kinder_rate_variation(dist)/income_variation(dist))
    end
  end

  def sw_lpov
    {:free_and_reduced_price_lunch_rate => statewide_lunch_average,
      :children_in_poverty_rate => sw_children_in_poverty_average,
      :high_school_graduation_rate => statewide_hs_grad_average}
  end

  def sw_ip
    {:median_household_income => statewide_median_household_income,
      :children_in_poverty_rate => sw_children_in_poverty_average}
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
    children_in_poverty_average(district) > sw_children_in_poverty_average
  end

  def higher_than_statewide_in_poverty_lunch_grad?(district)
    lunch_average(district) > statewide_lunch_average &&
    children_in_poverty_average(district) > sw_children_in_poverty_average &&
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

  def hp_hg_set(matching)
    {matching_districts: matching, statewide_average: ResultEntry.new(sw_lpov)}
  end

  def high_poverty_and_high_school_graduation
    matching = []
    dr.districts.map do |district|
        if includes_grad_lunch_poverty?(district) &&
        higher_than_statewide_in_poverty_lunch_grad?(district)
          matching << ResultEntry.new(lpg_new_result_entry(district))
        end
    end
    ResultSet.new(hp_hg_set(matching))
  end

  def hi_hp_set(matching)
    {matching_districts: matching, statewide_average: ResultEntry.new(sw_ip)}
  end

  def high_income_and_poverty
    matching = []
    dr.districts.map do |district|
        if includes_income_and_poverty?(district) &&
        higher_than_statewide_income_poverty?(district)
          matching << ResultEntry.new(pi_new_result_entry(district))
        end
    end
    ResultSet.new(hi_hp_set(matching))
  end

  def kinder_and_household?(district)
    district.enrollment.attributes[:kindergarten_participation] &&
    district.economic_profile.attributes[:median_household_income]
  end

  def statewide_correlation
    count = 0
    dr.districts.each do |district|
      if kinder_and_household?(district) && district.name != "COLORADO"
        result = kindergarten_participation_against_household_income(district)
        count += 1 if result.between?(0.6,1.5)
      end
    end
   count.to_f/dr.districts.count.to_f > 0.7 ? true : false
  end


  def across_correlation(districts)
    total = []
    districts.each do |district|
      dist = dr.find_by_name(district)
      if kinder_and_household?(dist)
        result = kindergarten_participation_against_household_income(dist)
        total << result
      end
    end
    final = total.inject(:+).to_f/districts.count.to_f
    final > 0.7 ? true : false
  end


  def kindergarten_participation_correlates_with_household_income(options)
    if options[:for] == "STATEWIDE"
      statewide_correlation
    elsif options[:across]
      across_correlation(options[:across])
    else
      district = dr.find_by_name(options[:for])
      result = kindergarten_participation_against_household_income(district)
      result.between?(0.6,1.5) ? true : false
    end

  end

end
