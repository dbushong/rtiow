require "./vec3"

def degrees_to_radians(degrees : Float64)
  degrees * Math::PI / 180.0
end

def random_in_unit_sphere
  loop do
    p = Vec3.random(-1, 1)
    return p if p.length_squared < 1
  end
end

def random_unit_vector
  random_in_unit_sphere.unit_vector
end

def random_in_hemisphere(normal : Vec3)
  in_unit_sphere = random_in_unit_sphere
  in_unit_sphere.dot(normal) > 0.0 ? in_unit_sphere : -in_unit_sphere
end
