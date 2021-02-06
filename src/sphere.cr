require "./ray"
require "./hittable"

class Sphere < Hittable
  getter center, radius, material

  def initialize(@center : Vec3, @radius : Float64, @material : Material)
  end

  def hit(r : Ray, t_min : Float64, t_max : Float64) : HitRecord?
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
    t = root
    outward_normal = (p - center) / radius
    u, v = get_sphere_uv(outward_normal)

    HitRecord.new(self, p, t, r, outward_normal, u, v)
  end

  def bounding_box(time0 : Float64, time1 : Float64) : AaBb?
    rv = Vec3.new(radius, radius, radius)
    AaBb.new(center - rv, center + rv)
  end

  private def get_sphere_uv(p : Vec3) : {Float64, Float64}
    # p: a given point on the sphere of radius one, centered at the origin.
    # u: returned value [0,1] of angle around the Y axis from X=-1.
    # v: returned value [0,1] of angle from Y=-1 to Y=+1.
    #     <1 0 0> yields <0.50 0.50>       <-1  0  0> yields <0.00 0.50>
    #     <0 1 0> yields <0.50 1.00>       < 0 -1  0> yields <0.50 0.00>
    #     <0 0 1> yields <0.25 0.50>       < 0  0 -1> yields <0.75 0.50>
    theta = Math.acos(-p.y)
    phi = Math.atan2(-p.z, p.x) + Math::PI
    {phi / (2 * Math::PI), theta / Math::PI}
  end
end
