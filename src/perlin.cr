PointCount = 256

class Perlin
  def initialize
    @ranfloat = StaticArray(Float64, PointCount).new { rand }
    @perm_x = Perlin.generate_perm
    @perm_y = Perlin.generate_perm
    @perm_z = Perlin.generate_perm
  end

  def noise(p : Vec3) : Float64
    u = p.x - p.x.floor
    v = p.y - p.y.floor
    w = p.z - p.z.floor
    u = u * u * (3 - 2*u)
    v = v * v * (3 - 2*v)
    w = w * w * (3 - 2*w)

    i = p.x.to_i
    j = p.y.to_i
    k = p.z.to_i

    c = StaticArray(StaticArray(StaticArray(Float64, 2), 2), 2).new do |di|
      StaticArray(StaticArray(Float64, 2), 2).new do |dj|
        StaticArray(Float64, 2).new do |dk|
          @ranfloat[@perm_x[(i + di) & (PointCount - 1)] ^
                    @perm_y[(j + dj) & (PointCount - 1)] ^
                    @perm_z[(k + dk) & (PointCount - 1)]]
        end
      end
    end

    Perlin.trilinear_interp c, u, v, w
  end

  def self.generate_perm : Array(Int32)
    p = Array(Int32).new(PointCount) { |i| i }
    permute p
    p
  end

  def self.permute(p : Array(Int32))
    (PointCount - 1).downto(1) do |i|
      target = rand(0...i)
      tmp = p[i]
      p[i] = p[target]
      p[target] = tmp
    end
  end

  def self.trilinear_interp(c, u, v, w)
    accum = 0.0
    0.upto(1) do |i|
      0.upto(1) do |j|
        0.upto(1) do |k|
          accum += (i*u + (1 - i)*(1 - u))*
                   (j*v + (1 - j)*(1 - v))*
                   (k*w + (1 - k)*(1 - w))*c[i][j][k]
        end
      end
    end
    accum
  end
end
