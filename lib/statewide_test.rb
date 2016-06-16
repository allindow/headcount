require_relative 'helper'
require_relative 'custom_errors'


class StatewideTest
  include Helper
  attr_reader       :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def parameter
      {3 => :third_grade, 8 => :eighth_grade,
        :asian => :asian, :pacific_islander => :pacific_islander,
        :black => :black, :hispanic => :hispanic,
        :native_american => :native_american,
        :two_or_more => :two_or_more, :white => :white, :reading => :reading,
        :writing => :writing, :math => :math
      }
    end

    def name
      attributes[:name]
    end

    def valid_data(subject, category, year)
      proficient_by_grade(category)[year] && attributes[parameter[category]]\
      && proficient_by_grade(category)[year][subject]
    end

    def proficient_by_grade(grade)
      raise UnknownDataError unless attributes[parameter[grade]]
        attributes[parameter[grade]]
    end

    def proficient_by_race_or_ethnicity(race_or_ethnicity)
        raise UnknownRaceError unless parameter[race_or_ethnicity]
          attributes[race_or_ethnicity]
    end

    def proficient_for_subject_by_grade_in_year(subject, grade, year)
      raise UnknownDataError unless valid_data(subject, grade, year)
      if (proficient_by_grade(grade)[year][subject]) > 0
        truncate_float(proficient_by_grade(grade)[year][subject])
      else
        "N/A"
      end
    end

    def proficient_for_subject_by_race_in_year(subject, race, year)
      raise UnknownDataError unless valid_data(subject, race, year)
      attributes[race][year][subject]
    end

end
