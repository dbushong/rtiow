require "./vec3"
require "./ray"
require "./aabb"

struct HitRecord
  getter p, normal, t, object, u, v

  @front_face : Bool

  def initialize(
    @object : Hittable,
    @p : Vec3,
    @t : Float64,
    r : Ray,
    outward_normal : Vec3,
    @u : Float64 = 0.0,
    @v : Float64 = 0.0
  )
    @front_face = r.direction.dot(outward_normal) < 0
    @normal = @front_face ? outward_normal : -outward_normal
  end

  def front_face?
    @front_face
  end
end

abstract class Hittable
  abstract def hit(r : Ray, t_min : Float64, t_max : Float64) : HitRecord?
  abstract def bounding_box(time0 : Float64, time1 : Float64) : AaBb?
end
