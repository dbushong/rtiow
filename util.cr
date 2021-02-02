def degrees_to_radians(degrees : Float64)
  degrees * Math::PI / 180.0
end

def clamp(x : Float64, min : Float64, max : Float64)
  return min if x < min
  return max if x > max
  x
end
