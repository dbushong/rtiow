require "./hittable"
require "./material"
require "./aabb"

class MovingSphere < Hittable
  getter material

  def initialize(
    @center0 : Vec3,
    @center1 : Vec3,
    @time0 : Float64,
    @time1 : Float64,
    @radius : Float64,
    @material : Material
  )
  end

  private def center(t : Float64)
    @center0 + (@center1 - @center0) * ((t - @time0) / (@time1 - @time0))
  end

  def hit(r : Ray, t_min : Float64, t_max : Float64) : HitRecord | Nil
    oc = r.origin - center(r.tm)
    a = r.direction.length_squared
    half_b = oc.dot(r.direction)
    c = oc.length_squared - @radius ** 2

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
    HitRecord.new(self, p, root, r, (p - center(r.tm)) / @radius)
  end

  def bounding_box(time0, time1) : AaBb
    rv = Vec3.new(@radius, @radius, @radius)
    c0 = center time0
    c1 = center time1
    AaBb.new(c0 - rv, c0 + rv).surrounding_box AaBb.new(c1 - rv, c1 + rv)
  end
end
