require 'pry'

module CSVParser

  def district_repo_parser(file_tree)
    filepath = file_tree.dig(:enrollment, :kindergarten)
    CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
      { :name => row[:location]}
    end
    #we could have .uniq at the end of the loop, but shouldn't we have multiple districts to reflect the actual data? ditto for enrollment_repo_parser
  end

  def enrollment_repo_parser(file_tree)
    filepath = file_tree.dig(:enrollment, :kindergarten)
    CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
       { :name => row[:location], row[:timeframe].to_i => row[:data].to_f }
     end
  end
end
