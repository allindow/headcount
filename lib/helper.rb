module Helper

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

  def group_names(all_parsed_data)
    all_parsed_data.group_by do |row|
      row[:name].upcase
    end
  end
  
end
