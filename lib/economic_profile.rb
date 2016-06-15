require_relative 'statewide_test'
require_relative 'statewide_parser'
require_relative 'custom_errors'

class EconomicProfile
  include Helper
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def name
    @attributes[:name]
  end

  def median_household_income_in_year(year)
    selection = attributes[:median_household_income].select do |years|
      year.between?(years[0], years[1])
    end
    sum = (selection.values.inject(:+))
    raise UnknownDataError       if sum.nil?
    sum/(selection.values.count) if sum
  end

  def median_household_income_average
    total_incomes = attributes[:median_household_income].values.inject(:+)
    incomes_count = attributes[:median_household_income].values.count
    total_incomes/incomes_count
  end

  def children_in_poverty_in_year(year)
    data = attributes[:children_in_poverty][year]
    raise UnknownDataError if data.nil?
    truncate_float(data)   if data
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    year_data = attributes[:free_or_reduced_price_lunch][year]
    raise UnknownDataError                 if year_data.nil?
    truncate_float(year_data[:percentage]) if year_data[:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    year_data = attributes[:free_or_reduced_price_lunch][year]
    raise UnknownDataError             if year_data.nil?
    truncate_float(year_data[:total])  if year_data[:total]
  end

  def title_i_in_year(year)
    year_data = attributes[:title_i][year]
    raise UnknownDataError          if year_data.nil?
    truncate_float(year_data)       if year_data
  end
end
