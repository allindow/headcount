require 'csv'
require_relative 'enrollment'
require 'pry'

class EnrollmentRepository
  include CSVParser

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def find_by_name(name)
    selection = @enrollments.select do |data_set|
      data_set.name.upcase == name.upcase
    end
    selection.empty? ? nil : selection[0]
  end

  def load_data(file_tree)
    enrollment_names = enrollment_repo_parser(file_tree)
    enrollment_names.each do |name|
    @enrollments << Enrollment.new(name)
    end
  end
end





















  # def name(name)
  #   @enrollments.find {|object|
  #
  # end


  # def load_data(file_tree)
  #   filepath = file_tree[:enrollment][:kindergarten]
  #
  #   years = CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
  #     { :name => row[:location], row[:timeframe].to_i => row[:data].to_f }
  #   end
  #
  #   per_enrollment_by_year = years.group_by do |row|
  #     row[:name]
  #   end
  #
  #   enrollment_data = per_enrollment_by_year.map do |name, years|
  #     merged =  years.reduce({}), :merge)
  #     merged.delete(:name)
  #
  #       { :name => name, kindergarten_participation }
  #   end
  #   pp stuff
  # end
  #
  # def find_by_name(name)
  #   @enrollments.find do |enrollment|
  #   enrollment.name == name
  #   end
  # end
