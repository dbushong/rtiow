require "./ray"
require "./util"

class Camera
  @origin : Vec3
  @horizontal : Vec3
  @vertical : Vec3
  @lower_left_corner : Vec3

  def initialize(look_from : Vec3, look_at : Vec3, vup : Vec3, vfov : Float64, aspect_ratio : Float64)
    theta = degrees_to_radians(vfov)
    h = Math.tan(theta / 2)
    viewport_height = 2.0 * h
    viewport_width = aspect_ratio * viewport_height

    w = (look_from - look_at).unit_vector
    u = vup.cross(w).unit_vector
    v = w.cross(u)

    @origin = look_from
    @horizontal = u * viewport_width
    @vertical = v * viewport_height
    @lower_left_corner = @origin \
      - @horizontal / 2.0 \
      - @vertical / 2.0 \
      - w
  end

  def ray(s : Float64, t : Float64)
    Ray.new(@origin, @lower_left_corner + @horizontal * s + @vertical * t - @origin)
  end
end
