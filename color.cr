require "./vec3"

class Color < Vec3
  def r
    x
  end

  def g
    y
  end

  def b
    z
  end

  def to_s(io : IO)
    io << (r * 255.999).to_i << ' ' << (g * 255.999).to_i << ' ' << (b * 255.999).to_i
  end
end
