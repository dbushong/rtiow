require "./ray"
require "./util"

class Camera
  @lower_left_corner : Vec3

  def initialize(vfov : Float64, aspect_ratio : Float64)
    theta = degrees_to_radians(vfov)
    h = Math.tan(theta / 2)
    viewport_height = 2.0 * h
    viewport_width = aspect_ratio * viewport_height

    focal_length = 1.0

    @origin = Vec3.new(0, 0, 0)
    @horizontal = Vec3.new(viewport_width, 0, 0)
    @vertical = Vec3.new(0, viewport_height, 0)
    @lower_left_corner = @origin \
      - @horizontal / 2.0 \
      - @vertical / 2.0 \
      - Vec3.new(0, 0, focal_length)
  end

  def ray(u : Float64, v : Float64)
    Ray.new(@origin, @lower_left_corner + @horizontal * u + @vertical * v - @origin)
  end
end
