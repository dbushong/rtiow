class Vec3
  property x, y, z

  def initialize(@x : Float64, @y : Float64, @z : Float64)
  end

  def *(n : Float64)
    typeof(self).new(x * n, y * n, z * n)
  end

  def -
    self * -1.0
  end

  def -(v : Vec3)
    typeof(self).new(x - v.x, y - v.y, z - v.z)
  end

  def +(v : Vec3)
    typeof(self).new(x + v.x, y + v.y, z + v.z)
  end

  def *(v : Vec3)
    typeof(self).new(x * v.x, y * v.y, z * v.z)
  end

  def /(v : Vec3)
    typeof(self).new(x / v.x, y / v.y, z / v.z)
  end

  def /(n : Float64)
    self * (1.0 / n)
  end

  def dot(v : Vec3)
    x * v.x + y * v.y + z * v.z
  end

  def cross(v : Vec3)
    typeof(self).new(
      y * v.z - z * v.y,
      z * v.x - x * v.z,
      x * v.y - y * v.x
    )
  end

  def reflect(v : Vec3)
    self - v * self.dot(v) * 2.0
  end

  def length_squared
    x*x + y*y + z*z
  end

  def length
    Math.sqrt length_squared
  end

  def unit_vector
    self / length
  end

  def to_s(io : IO)
    io << x << ' ' << y << ' ' << z
  end

  def near_zero?
    s = 1.0e-8
    x.abs < s && y.abs < s && z.abs < s
  end

  def refract(v : Vec3, etai_over_etat : Float64)
    cos_theta = Math.min(self.dot(-v), 1.0)
    r_out_perp = (self + v * cos_theta) * etai_over_etat
    r_out_parallel = -v * Math.sqrt((1.0 - r_out_perp.length_squared).abs)
    r_out_perp + r_out_parallel
  end

  def self.random
    self.new(Random.rand, Random.rand, Random.rand)
  end

  def self.random(min : Float64, max : Float64)
    self.new(Random.rand(min..max), Random.rand(min..max), Random.rand(min..max))
  end
end
