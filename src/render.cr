require "./vec3"
require "./ray"
require "./hittable_list"
require "./sphere"
require "./camera"
require "./util"
require "./material"
require "./scene"

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

ValidSceneNames = ["cover", "two-spheres"]

def render(image_width, image_height, samples_per_pixel, max_depth, scene_name)
  # Image
  aspect_ratio = image_width.to_f / image_height

  # World + Scene
  world = HittableList.new
  scene = Scene.create(scene_name)

  scene.render_to(world)

  # Camera
  vup = Vec3.new(0, 1, 0)
  dist_to_focus = 10.0

  cam = Camera.new(
    look_from: scene.look_from,
    look_at: scene.look_at,
    vup: vup,
    vfov: scene.vfov,
    aspect_ratio: aspect_ratio,
    aperture: scene.aperture,
    focus_dist: dist_to_focus,
    time0: 0.0,
    time1: 1.0
  )

  # Render
  STDOUT << "P3\n" << image_width << ' ' << image_height << "\n255\n"

  (image_height - 1).downto(0) do |j|
    STDERR << "\rScanlines remaining: " << j << ' '
    0.upto(image_width - 1) do |i|
      pixel_color = Color.new(0, 0, 0)
      samples_per_pixel.times do
        u = (i + rand) / (image_width - 1)
        v = (j + rand) / (image_height - 1)
        r = cam.ray(u, v)
        pixel_color += ray_color(r, world, max_depth)
      end
      pixel_color.write_as_color(STDOUT, samples_per_pixel) << '\n'
    end
  end

  STDERR << "\nDone.\n"
end
