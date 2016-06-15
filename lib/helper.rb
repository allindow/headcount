module Helper

  def truncate_float(float)
    # "Pure" function
    (float * 1000).floor / 1000.to_f
  end

end
