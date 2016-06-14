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
      path_counter += 1
    end
    all_data.uniq
  end

  def parsed_enrollment_data(filepath)
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

  def parsed_test_data(file_tree, path_counter)
    filepath = file_tree.values[0].values[path_counter]
    grade_level = file_tree.values[0].keys[path_counter]
    CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
      if row.headers.include? :score
        { name: row[:location].upcase, grade_level => {row[:timeframe].to_i => {row[:score].downcase.to_sym => row[:data].to_f}}}
      else
        if row[:race_ethnicity].downcase == "hawaiian/pacific islander"
          row[:race_ethnicity] = "pacific islander"
        end
        { name: row[:location].upcase, row[:race_ethnicity].gsub(" ","_").downcase.to_sym => {row[:timeframe].to_i => {file_tree.values[0].keys[path_counter] => row[:data].to_f}}}
      end
    end
  end

  def statewide_test_repo_parser(file_tree)
    all_data = []
    file_tree.values[0].values.count.times { |n| all_data << parsed_test_data(file_tree, n) }
    by_district = group_names(all_data.flatten)
    new_hash = {}
    by_district.values.map do |district_set|
      district_set.each do |district_record|
        district, category, subject, year, data_point = record_data(district_record)
        update_new_data(district_record, new_hash, district, category, subject, year, data_point)
      end
    end
    new_hash.values
  end

  def update_new_data(district_record, new_hash, district, category, subject, year, data_point)
    new_hash[district] = district_record                             if district_new?(new_hash, district)
    new_hash[district][category][year][subject] = data_point         if subject_new?(new_hash, district, category, year)
    new_hash[district][category][year] = {subject => data_point}     if year_new?(new_hash, district, category, year)
    new_hash[district][category] = {year => {subject => data_point}} if category_new?(new_hash, district, category)
    new_hash
  end

  def district_new?(new_hash, district)
    new_hash[district].nil?
  end

  def subject_new?(new_hash, district, category, year)
    new_hash.key?(district) && new_hash[district].key?(category) && new_hash[district][category].key?(year)
  end

  def year_new?(new_hash, district, category, year)
    new_hash.key?(district) && new_hash[district].key?(category) && new_hash[district][category].key?(year) == false
  end

  def category_new?(new_hash, district, category)
    new_hash.key?(district) && new_hash[district].key?(category) == false
  end

  def record_data(district_record)
    [district_record[:name],
     district_record.keys[1],
     district_record[district_record.keys[1]].values[0].keys[0],
     district_record[district_record.keys[1]].keys[0],
     district_record[district_record.keys[1]].values[0].values[0]]
   end

end
