require "./vec3"
require "./ray"
require "./color"
require "./hittable_list"
require "./sphere"

def ray_color(r : Ray, world : Hittable) : Color
  rec = world.hit(r, 0, Float64::INFINITY)
  if rec
    return (Color.new(1, 1, 1) + rec.normal) * 0.5
  end
  t = (r.direction.unit_vector.y + 1.0) * 0.5
  Color.new(1.0, 1.0, 1.0) * (1 - t) + Color.new(0.5, 0.7, 1.0) * t
end

def main
  # Image
  aspect_ratio = 16.0 / 9.0
  image_width = 400
  image_height = (image_width / aspect_ratio).to_i

  # World
  world = HittableList.new \
    << Sphere.new(Vec3.new(0, 0, -1), 0.5) \
      << Sphere.new(Vec3.new(0, -100.5, -1), 100.0)

  # Camera
  viewport_height = 2.0
  viewport_width = aspect_ratio * viewport_height
  focal_length = 1.0

  origin = Vec3.new(0, 0, 0)
  horizontal = Vec3.new(viewport_width, 0, 0)
  vertical = Vec3.new(0, viewport_height, 0)
  lower_left_corner = origin - horizontal / 2.0 - vertical / 2.0 \
    - Vec3.new(0, 0, focal_length)

  # Render
  STDOUT << "P3\n" << image_width << ' ' << image_height << "\n255\n"

  (image_height - 1).downto(0) do |j|
    STDERR << "\rScanlines remaining: " << j << ' '
    0.upto(image_width - 1) do |i|
      u = i / (image_width - 1)
      v = j / (image_height - 1)
      r = Ray.new(origin, lower_left_corner + horizontal * u + vertical * v - origin)
      STDOUT << ray_color(r, world) << '\n'
    end
  end

  STDERR << "\nDone.\n"
end

main()
