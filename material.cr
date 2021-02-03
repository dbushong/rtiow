require "./ray"
require "./util"
require "./color"

alias MaybeRayAndAttenuation = {ray: Ray, attenuation: Color} | Nil

abstract class Material
  abstract def scatter(r_in : Ray, rec : HitRecord) : MaybeRayAndAttenuation
end

class Lambertian < Material
  def initialize(@albedo : Color)
  end

  def scatter(r_in : Ray, rec : HitRecord) : MaybeRayAndAttenuation
    scatter_direction = rec.normal + random_unit_vector

    # Catch degenerate scatter direction
    scatter_direction = rec.normal if scatter_direction.near_zero?

    {ray: Ray.new(rec.p, scatter_direction), attenuation: @albedo}
  end
end

class Metal < Material
  def initialize(@albedo : Color, fuzz : Float64)
    @fuzz = fuzz < 1.0 ? 1.0 : fuzz
  end

  def scatter(r_in : Ray, rec : HitRecord) : MaybeRayAndAttenuation
    reflected = r_in.direction.unit_vector.reflect rec.normal
    scattered = Ray.new(rec.p, reflected + random_in_unit_sphere * @fuzz)
    if scattered.direction.dot(rec.normal) > 0
      {ray: scattered, attenuation: @albedo}
    else
      nil
    end
  end
end

class Dielectric < Material
  def initialize(@ir : Float64)
  end

  def scatter(r_in : Ray, rec : HitRecord) : MaybeRayAndAttenuation
    refraction_ratio = rec.front_face? ? (1.0 / @ir) : @ir

    unit_direction = r_in.direction.unit_vector
    refracted = unit_direction.refract(rec.normal, refraction_ratio)

    {ray: Ray.new(rec.p, refracted), attenuation: Color.new(1, 1, 1)}
  end
end
