require 'pry'

module CSVParser
  class ::Hash
    def deep_merge(second)
      merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
      self.merge(second.to_h, &merger)
    end
  end

  def district_repo_parser(file_tree)
    filepath = file_tree.dig(:enrollment, :kindergarten)
    CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
      { :name => row[:location].upcase}
    end.uniq
  end

  def header_set(filepath)
    CSV.open(filepath, headers: true, header_converters: :symbol)
  end

  def parsed_data(data)
    data.map do |row|
      { name: row[:location], row[:timeframe].to_i => row[:data].to_f}
    end
  end

  def group_names(all_parsed_data)
    all_parsed_data.group_by do |row|
      row[:name].upcase
    end
  end

  def year_merge(enrollment_by_year)
    enrollment_by_year.map do |name, years|
      year_data = years.reduce({}, :merge)
      year_data.delete(:name)
      {:name => name, :kindergarten_participation => year_data }
    end
  end

  def enrollment_repo_parser(file_tree)
    filepath = file_tree.dig(:enrollment, :kindergarten)
    data = header_set(filepath)
    all_parsed_data = parsed_data(data)
    enrollment_by_year = group_names(all_parsed_data)
    enrollment_data = year_merge(enrollment_by_year)
  end

end
