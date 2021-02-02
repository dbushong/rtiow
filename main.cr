require "./vec3"
require "./ray"
require "./color"

def hit_sphere(center : Vec3, radius : Float64, r : Ray)
  oc = r.origin - center
  a = r.direction.dot(r.direction)
  b = 2.0 * oc.dot(r.direction)
  c = oc.dot(oc) - radius * radius
  discriminant = b * b - 4 * a * c
  if discriminant < 0
    -1.0
  else
    (-b - Math.sqrt(discriminant)) / (2.0 * a)
  end
end

def ray_color(r : Ray) : Color
  t = hit_sphere(Vec3.new(0, 0, -1), 0.5, r)
  if t > 0.0
    n = (r.at(t) - Vec3.new(0, 0, -1)).unit_vector
    return Color.new(n.x + 1, n.y + 1, n.z + 1) * 0.5
  end
  unit_direction = r.direction.unit_vector
  t = 0.5 * (unit_direction.y + 1.0)
  Color.new(1.0, 1.0, 1.0) * (1 - t) + Color.new(0.5, 0.7, 1.0) * t
end

def main
  # Image
  aspect_ratio = 16.0 / 9.0
  image_width = 400
  image_height = (image_width / aspect_ratio).to_i

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
      STDOUT << ray_color(r) << '\n'
    end
  end

  STDERR << "\nDone.\n"
end

main()
