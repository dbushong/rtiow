require "./vec3"

struct Ray
  property origin, direction

  def initialize(@origin : Vec3, @direction : Vec3)
  end

  def at(t : Float64)
    origin + direction * t
  end
end
