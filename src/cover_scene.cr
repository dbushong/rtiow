require "./hittable_list"
require "./material"
require "./sphere"
require "./moving_sphere"
require "./vec3"
require "./texture"

def cover_scene(world : HittableList)
  checker = Checker.new(Color.new(0.2, 0.3, 0.1), Color.new(0.9, 0.9, 0.9))

  world << Sphere.new(Vec3.new(0, -1000, 0), 1000, Lambertian.new(checker))

  -11.upto(10) do |a|
    -11.upto(10) do |b|
      choose_mat = rand
      center = Vec3.new(a + 0.9 * rand, 0.2, b + 0.9 * rand)

      if (center - Vec3.new(4, 0.2, 0)).length > 0.9
        if choose_mat < 0.8
          # diffuse
          albedo = Color.random * Color.random
          sphere_material = Lambertian.new(albedo)
          center2 = center + Vec3.new(0, rand(0.0..0.5), 0)
          world << MovingSphere.new(
            center, center2, 0.0, 1.0, 0.2, sphere_material
          )
        elsif choose_mat < 0.95
          # metal
          albedo = Color.random(0.5, 1)
          fuzz = rand(0.0..0.5)
          sphere_material = Metal.new(albedo, fuzz)
          world << Sphere.new(center, 0.2, sphere_material)
        else
          # glass
          sphere_material = Dielectric.new(1.5)
          world << Sphere.new(center, 0.2, sphere_material)
        end
      end
    end
  end

  world << Sphere.new(Vec3.new(0, 1, 0), 1.0, Dielectric.new(1.5))
  world << Sphere.new(
    Vec3.new(-4, 1, 0), 1.0, Lambertian.new(Color.new(0.4, 0.2, 0.1))
  )
  world << Sphere.new(
    Vec3.new(4, 1, 0), 1.0, Metal.new(Color.new(0.7, 0.6, 0.5), 0.0)
  )
end
