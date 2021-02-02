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
end
