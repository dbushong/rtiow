require "./ray"
require "./hittable"

class Sphere < Hittable
  getter center, radius, material

  def initialize(@center : Vec3, @radius : Float64, @material : Material)
  end

  def hit(r : Ray, t_min : Float64, t_max : Float64) : HitRecord | Nil
    oc = r.origin - center
    a = r.direction.length_squared
    half_b = oc.dot(r.direction)
    c = oc.length_squared - radius ** 2

    discriminant = half_b ** 2 - a * c
    return nil if discriminant < 0
    sqrtd = Math.sqrt discriminant

    # Find the nearest root that lies in the acceptable range
    root = (-half_b - sqrtd) / a
    if root < t_min || t_max < root
      root = (-half_b + sqrtd) / a
      return nil if root < t_min || t_max < root
    end

    p = r.at(root)
    HitRecord.new(self, p, root, r, (p - center) / radius)
  end

  def bounding_box(time0 : Float64, time1 : Float64) : AaBb?
    rv = Vec3.new(radius, radius, radius)
    AaBb.new(center - rv, center + rv)
  end
end
