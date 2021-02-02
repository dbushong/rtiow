require "./vec3"

class Ray
  property origin, direction

  def initialize(@origin : Vec3, @direction : Vec3)
  end

  def at(t : Float64)
    origin + t * direction
  end
end
