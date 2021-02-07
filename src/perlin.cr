PointCount = 256

class Perlin
  def initialize
    @ranfloat = Array(Float64).new(PointCount) { rand }
    @perm_x = Perlin.generate_perm
    @perm_y = Perlin.generate_perm
    @perm_z = Perlin.generate_perm
  end

  def noise(p : Vec3) : Float64
    i = (p.x * 4).to_i & 255
    j = (p.y * 4).to_i & 255
    k = (p.z * 4).to_i & 255

    @ranfloat[@perm_x[i] ^ @perm_y[j] ^ @perm_z[k]]
  end

  def self.generate_perm : Array(Int32)
    p = Array(Int32).new(PointCount) { |i| i }

    (PointCount - 1).downto(1) do |i|
      target = rand(0..i)
      tmp = p[i]
      p[i] = p[target]
      p[target] = tmp
    end

    p
  end
end
