require 'pry'

module CSVParser

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

     #need to figure out how to merge additional years to the kindergarten_particpation value hash

    #  end
  end

end
