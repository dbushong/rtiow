require "./vec3"

struct Ray
  getter origin, direction, tm

  def initialize(@origin : Vec3, @direction : Vec3, @tm = 0.0)
  end

  def at(t : Float64)
    origin + direction * t
  end
end
