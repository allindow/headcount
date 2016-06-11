require 'pry'
class Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
    self.merge(second.to_h, &merger)
  end
end
module CSVParser


  def district_repo_parser(file_tree)
    path_counter = 0
    all_data = []
    i = file_tree.values[0].values.count
    i.times do
      filepath = file_tree.values[0].values[path_counter]
    CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
      all_data << { :name => row[:location].upcase}
    end
  end
  all_data.uniq
end

  def parsed_data(filepath)
    CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
      { name: row[:location].upcase, row[:timeframe].to_i => row[:data].to_f}
    end
  end

  def group_names(all_parsed_data)
    all_parsed_data.group_by do |row|
      row[:name].upcase
    end
  end

  def year_merge(grade_level, enrollment_by_year)
    enrollment_by_year.map do |name, years|
      year_data = years.reduce({}, :merge)
      year_data.delete(:name)
      {:name => name, grade_level => year_data }
    end
  end

  def name_sort(all_data)
    all_data.group_by do |hash|
      hash[:name]
    end
  end

  def combined_enrollment_by_year(all_data)
    sorted_by_name = name_sort(all_data)
    sorted_by_name.values.map do |district_set|
      district_set.reduce({}, :merge)
    end
  end

  def enrollment_repo_parser(file_tree)
    path_counter = 0
    all_data = []
     i = file_tree.values[0].values.count
     i.times do
       filepath = file_tree.values[0].values[path_counter]
       all_parsed_data = parsed_data(filepath)
       enrollment_by_year = group_names(all_parsed_data)
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
     binding.pry
    combined_enrollment_by_year(all_data)
  end
end
