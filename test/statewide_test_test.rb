require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'rake/testtask'
require './lib/statewide_test_repository'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_can_get_third_grade_data
    skip


 #    statewide_test.proficient_by_grade(3)
 # { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
 #     2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
 #     2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
 #     2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
 #     2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
 #     2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
 #     2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
 #   }


 end
end
