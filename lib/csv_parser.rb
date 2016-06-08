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
      { :name => row[:location]}
    end.uniq
  end

  def enrollment_repo_parser(file_tree)
    filepath = file_tree.dig(:enrollment, :kindergarten)
    file = CSV.open(filepath, headers: true, header_converters: :symbol)
    all_data = file.map do |row|
      { name: row[:location], row[:timeframe].to_i => row[:data].to_f}
    end
    enrollment_by_year = all_data.group_by do |row|
      row[:name]
    end
    enrollment_data = enrollment_by_year.map do |name, years|
      year_data = years.reduce({}, :merge)
      year_data.delete(:name)
      {:name => name, :kindergarten_participation => year_data }
    end
    enrollment_data
  end

end
