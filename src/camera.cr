require "./ray"
require "./util"

struct Camera
  @origin : Vec3
  @horizontal : Vec3
  @vertical : Vec3
  @lower_left_corner : Vec3
  @lens_radius : Float64
  @u : Vec3
  @v : Vec3
  @w : Vec3

  def initialize(
    *,
    look_from : Vec3,
    look_at : Vec3,
    vup : Vec3,
    vfov : Float64, # vertical field-of-view in degrees
    aspect_ratio : Float64,
    aperture : Float64,
    focus_dist : Float64,
    @time0 : Float64 = 0,
    @time1 : Float64 = 0
  )
    theta = degrees_to_radians(vfov)
    h = Math.tan(theta / 2)
    viewport_height = 2.0 * h
    viewport_width = aspect_ratio * viewport_height

    @w = (look_from - look_at).unit_vector
    @u = vup.cross(@w).unit_vector
    @v = @w.cross(@u)

    @origin = look_from
    @horizontal = @u * (focus_dist * viewport_width)
    @vertical = @v * (focus_dist * viewport_height)
    @lower_left_corner = @origin \
      - @horizontal / 2.0 \
      - @vertical / 2.0 \
      - @w * focus_dist
    @lens_radius = aperture / 2
  end

  def ray(s : Float64, t : Float64)
    rd = random_in_unit_disc * @lens_radius
    offset = @u * rd.x + @v * rd.y

    Ray.new(
      @origin + offset,
      @lower_left_corner + @horizontal * s + @vertical * t - @origin - offset,
      rand @time0..@time1
    )
  end
end
