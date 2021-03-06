require_relative 'helper'

module EnrollmentParser
  include Helper

  def parsed_enrollment_data(path)
    CSV.foreach(path, headers: true, header_converters: :symbol).map do |row|
      { name: row[:location].upcase, row[:timeframe].to_i => row[:data].to_f}
    end
  end

  def year_merge(grade_level, enrollment_by_year)
    enrollment_by_year.map do |name, years|
      year_data = years.reduce({}, :merge)
      year_data.delete(:name)
      {:name => name, grade_level => year_data }
    end
  end

  def combined_enrollment_by_year(all_data)
    group_names(all_data).values.map do |district_set|
      district_set.reduce({}, :merge)
    end
  end

  def enrollment_repo_parser(file_tree)
    path_counter = 0
    all_data = []
    i = file_tree.values[0].values.count
    i.times do
      filepath = file_tree.values[0].values[path_counter]
      enrollment_by_year = group_names(parsed_enrollment_data(filepath))
      if file_tree.values[0].keys[path_counter] == :kindergarten
        grade_level = :kindergarten_participation
      else
        grade_level = file_tree.values[0].keys[path_counter]
      end
      year_merge(grade_level, enrollment_by_year).each do |data_set|
        all_data << (data_set)
      end
      path_counter += 1
    end
    combined_enrollment_by_year(all_data)
  end

end
