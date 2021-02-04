require "./ray"
require "./util"

alias MaybeRayAndAttenuation = {ray: Ray, attenuation: Color} | Nil

abstract struct Material
  abstract def scatter(r_in : Ray, rec : HitRecord) : MaybeRayAndAttenuation
end

struct Lambertian < Material
  def initialize(@albedo : Color)
  end

  def scatter(r_in : Ray, rec : HitRecord) : MaybeRayAndAttenuation
    scatter_direction = rec.normal + random_unit_vector

    # Catch degenerate scatter direction
    scatter_direction = rec.normal if scatter_direction.near_zero?

    {ray: Ray.new(rec.p, scatter_direction), attenuation: @albedo}
  end
end

struct Metal < Material
  def initialize(@albedo : Color, fuzz : Float64)
    @fuzz = fuzz < 1.0 ? fuzz : 1.0
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

struct Dielectric < Material
  def initialize(@ir : Float64)
  end

  def scatter(r_in : Ray, rec : HitRecord) : MaybeRayAndAttenuation
    refraction_ratio = rec.front_face? ? (1.0 / @ir) : @ir

    unit_direction = r_in.direction.unit_vector
    cos_theta = Math.min((-unit_direction).dot(rec.normal), 1.0)
    sin_theta = Math.sqrt(1.0 - cos_theta ** 2)

    cannot_refract = refraction_ratio * sin_theta > 1.0
    direction = if cannot_refract || reflectance(cos_theta, refraction_ratio) > Random.rand
                  unit_direction.reflect(rec.normal)
                else
                  unit_direction.refract(rec.normal, refraction_ratio)
                end

    {ray: Ray.new(rec.p, direction), attenuation: Color.new(1, 1, 1)}
  end

  private def reflectance(cosine : Float64, ref_idx : Float64)
    # Use Schlick's approximation for reflectance
    r0 = ((1 - ref_idx) / (1 + ref_idx)) ** 2
    r0 + (1 - r0) * (1 - cosine) ** 5
  end
end
