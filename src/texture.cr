require "./vec3"

abstract class Texture
  abstract def value(u : Float64, v : Float64, p : Vec3) : Color
end

class SolidColor < Texture
  def initialize(@color : Color)
  end

  def value(u, v, p) : Color
    @color
  end
end

class Checker < Texture
  def initialize(@even : Texture, @odd : Texture)
  end

  def initialize(even : Color, odd : Color)
    @even = SolidColor.new(even)
    @odd = SolidColor.new(odd)
  end

  def value(u, v, p) : Color
    sines = Math.sin(10 * p.x) * Math.sin(10 * p.y) * Math.sin(10 * p.z)
    (sines < 0 ? @odd : @even).value(u, v, p)
  end
end
