require "./vec3"
require "./ray"
require "./color"
require "./hittable_list"
require "./sphere"
require "./camera"
require "./util"
require "./material"

R = Math.cos(Math::PI / 4.0)

def ray_color(r : Ray, world : Hittable, depth : Int32) : Color
  return Color.new(0, 0, 0) if depth <= 0

  rec = world.hit(r, 0.001, Float64::INFINITY)
  if rec
    scatter_res = rec.object.material.scatter(r, rec)
    if scatter_res
      return ray_color(scatter_res[:ray], world, depth - 1) * scatter_res[:attenuation]
    else
      return Color.new(0, 0, 0)
    end
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
  material_left = Lambertian.new(Color.new(0, 0, 1))
  material_right = Lambertian.new(Color.new(1, 0, 0))

  world = HittableList.new
  world << Sphere.new(Vec3.new(-R, 0, -1), R, material_left)
  world << Sphere.new(Vec3.new(R, 0, -1), R, material_right)

  # Camera
  cam = Camera.new(90, aspect_ratio)

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
