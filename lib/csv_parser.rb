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
    #we could have .uniq at the end of the loop, but shouldn't we have multiple districts to reflect the actual data? ditto for enrollment_repo_parser
    #no, we just want to know at this point what are the districts.
  end

  def sorted_data(file)
  all_data = file.map do |row|
    # if row[:location] == nil
    #   row[:location] = "UNKNOWN"
    # else
    #   row[:location]
    # end
      { :name => row[:location], :kindergarten_participation => {row[:timeframe].to_i => row[:data].to_f }}
  end
  all_data.sort_by! { |key| key[:name] }
end

  def enrollment_repo_parser(file_tree)
    filepath = file_tree.dig(:enrollment, :kindergarten)
    file = CSV.open(filepath, headers: true, header_converters: :symbol)
    clean = sorted_data(file)
     enrollment_data = {}
     num = 0
     final = []
     clean.map do |set|
       require "pry"; binding.pry
       if clean[num][:name].upcase == clean[num+1][:name].upcase
      enrollment_data = enrollment_data.deep_merge(clean[num].deep_merge(clean[num+1]))
      num += 1
    elsif clean[num][:name].upcase != clean[num+1][:name].upcase
      final << enrollment_data
      enrollment_data = {}
        enrollment_data = enrollment_data.deep_merge(clean[num].deep_merge(clean[num+1]))
        num += 1
        # require "pry"; binding.pry
    end
    final
###   this method mosly works but as some point it is returning nil...need to use test_data to narrow down the problem.
   end

  end
end
