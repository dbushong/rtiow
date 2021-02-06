struct AaBb
  getter min, max

  def initialize(@min : Vec3, @max : Vec3)
  end

  def hit(r : Ray, t_min : Float64, t_max : Float64)
    0.upto(2) do |a|
      inv_d = 1.0 / r.direction[a]
      o = r.origin[a]
      t0 = (min[a] - o) * inv_d
      t1 = (max[a] - o) * inv_d
      t0, t1 = t1, t0 if inv_d < 0
      t_min = Math.max(t0, t_min)
      t_max = Math.max(t1, t_max)
      return false if t_max <= t_min
    end
    true
  end

  def surrounding_box(other : AaBb) : AaBb
    small = Vec3.new(
      Math.min(min.x, other.min.x),
      Math.min(min.y, other.min.y),
      Math.min(min.z, other.min.z)
    )
    big = Vec3.new(
      Math.max(max.x, other.max.x),
      Math.max(max.y, other.max.y),
      Math.max(max.z, other.max.z)
    )
    AaBb.new(small, big)
  end
end
