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

  def enrollment_repo_parser(file_tree)
    filepath = file_tree.dig(:enrollment, :kindergarten)
    file = CSV.open(filepath, headers: true, header_converters: :symbol)
    all_data = file.map do |row|
       { :name => row[:location], :kindergarten_participation => {row[:timeframe].to_i => row[:data].to_f }}
     end
     enrollment_data = {}
     num = 0
     final = []
     all_data.map do |set|
       if all_data[num][:name].upcase == all_data[num+1][:name].upcase
      enrollment_data = enrollment_data.deep_merge(all_data[num].deep_merge(all_data[num+1]))
      num += 1
    elsif all_data[num][:name].upcase != all_data[num+1][:name].upcase
        enrollment_data = enrollment_data.deep_merge(all_data[num].deep_merge(all_data[num+1]))
        final << enrollment_data
        enrollment_data = {}
        num += 1
    end
###   this method mosly works but as some point it is returning nil...need to use test_data to narrow down the problem.
   end

  end
