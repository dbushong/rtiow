require "./vec3"
require "./ray"
require "./color"
require "./hittable_list"
require "./sphere"
require "./camera"

def random_in_unit_sphere
  loop do
    p = Vec3.random(-1, 1)
    return p if p.length_squared < 1
  end
end

def random_unit_vector
  random_in_unit_sphere.unit_vector
end

def random_in_hemisphere(normal : Vec3)
  in_unit_sphere = random_in_unit_sphere
  in_unit_sphere.dot(normal) > 0.0 ? in_unit_sphere : -in_unit_sphere
end

def ray_color(r : Ray, world : Hittable, depth : Int32) : Color
  return Color.new(0, 0, 0) if depth <= 0

  rec = world.hit(r, 0.001, Float64::INFINITY)
  if rec
    target = rec.p + random_in_hemisphere(rec.normal)
    return ray_color(Ray.new(rec.p, target - rec.p), world, depth - 1) * 0.5
  end

  t = (r.direction.unit_vector.y + 1.0) * 0.5
  Color.new(1.0, 1.0, 1.0) * (1 - t) + Color.new(0.5, 0.7, 1.0) * t
end

def main
  # Image
  aspect_ratio = 16.0 / 9.0
  image_width = 400
  image_height = (image_width / aspect_ratio).to_i
  samples_per_pixel = 100
  max_depth = 50

  # World
  world = HittableList.new \
    << Sphere.new(Vec3.new(0, 0, -1), 0.5) \
      << Sphere.new(Vec3.new(0, -100.5, -1), 100.0)

  # Camera
  cam = Camera.new

  # Render
  STDOUT << "P3\n" << image_width << ' ' << image_height << "\n255\n"

  (image_height - 1).downto(0) do |j|
    STDERR << "\rScanlines remaining: " << j << ' '
    0.upto(image_width - 1) do |i|
      pixel_color = Color.new(0, 0, 0)
      samples_per_pixel.times do
        u = (i + Random.rand) / (image_width - 1)
        v = (j + Random.rand) / (image_height - 1)
        r = cam.ray(u, v)
        pixel_color += ray_color(r, world, max_depth)
      end
      pixel_color.write_color(STDOUT, samples_per_pixel) << '\n'
    end
  end

  STDERR << "\nDone.\n"
end

main()
