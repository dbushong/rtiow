require "./ray"
require "./hittable"

class Sphere < Hittable
  property center, radius

  def initialize(@center : Vec3, @radius : Vec3)
  end

  def hit(r : Ray, t_min : Float64, t_max : Float64, rec : HitRecord) : Bool
    oc = r.origin - center
    a = r.direction.length_squared
    half_b = oc.dot(r.direction)
    c = oc.length_squared - radius * radius

    discriminant = half_b * half_b - a * c
    return false if discriminant < 0
    sqrtd = Math.sqrt discriminant

    # Find the nearest root that lies in the acceptable range
    root = (-half_b - sqrtd) / a
    if root < t_min || t_max < root
      root = (-half_b + sqrtd) / a
      return false if root < t_min || t_max < root
    end

    rec.t = root
    rec.p = r.at(rec.t)
    rec.set_face_normal(r, (rec.p - center) / radius)

    true
  end
end
