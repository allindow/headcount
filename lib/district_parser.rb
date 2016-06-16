require 'csv'

module DistrictParser

  def district_repo_parser(file_tree)
    all_data = []
    files = file_tree.values.reduce({}, :merge!)
    i = files.count
    path_counter = 0
    i.times do
      path = files[files.keys[path_counter]]
      CSV.foreach(path, headers: true, header_converters: :symbol).each do |row|
        district = { :name => row[:location].upcase}
        if row[:location] && all_data.include?(district) == false
        all_data << district
        end
      end
      path_counter += 1
    end
    all_data
  end

end
