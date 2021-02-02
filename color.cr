require "./vec3"
require "./util"

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

  def write_color(io : IO, samples_per_pixel : Int32)
    scale = 1.0 / samples_per_pixel

    io << (clamp(r * scale, 0.0, 0.999) * 256).to_i << ' ' \
      << (clamp(g * scale, 0.0, 0.999) * 256).to_i << ' ' \
        << (clamp(b * scale, 0.0, 0.999) * 256).to_i
  end
end
