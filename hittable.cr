require "./vec3"
require "./ray"

class HitRecord
  getter p, normal, t, front_face : Bool

  def initialize(@p : Vec3, @t : Float64, r : Ray, outward_normal : Vec3)
    @front_face = r.direction.dot(outward_normal) < 0
    @normal = front_face ? outward_normal : -outward_normal
  end
end

abstract class Hittable
  abstract def hit(r : Ray, t_min : Float64, t_max : Float64) : HitRecord | Nil
end
