require "./vec3"
require "./ray"
require "./color"
require "./hittable_list"
require "./sphere"
require "./camera"
require "./util"
require "./material"

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
  material_ground = Lambertian.new(Color.new(0.8, 0.8, 0.0))
  material_center = Lambertian.new(Color.new(0.1, 0.2, 0.5))
  material_left = Dielectric.new(1.5)
  material_right = Metal.new(Color.new(0.8, 0.6, 0.2), 0.0)

  world = HittableList.new
  world << Sphere.new(Vec3.new(0, -100.5, -1), 100.0, material_ground)
  world << Sphere.new(Vec3.new(0, 0, -1), 0.5, material_center)
  world << Sphere.new(Vec3.new(-1, 0, -1), 0.5, material_left)
  world << Sphere.new(Vec3.new(-1, 0, -1), -0.4, material_left)
  world << Sphere.new(Vec3.new(1, 0, -1), 0.5, material_right)

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
