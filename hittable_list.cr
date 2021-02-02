class HittableList < Hittable
  def initialize
    @objects = [] of Hittable
  end

  def <<(obj : Hittable)
    @objects << obj
  end

  def clear
    @objects.clear
  end

  def hit(r : Ray, t_min : Float64, t_max : Float64, rec : HitRecord)
    temp_rec = HitRecord.new
    hit_anything = false
    closest_so_far = t_max

    @objects.each do |object|
      if object.hit(r, t_min, closest_so_far, temp_rec)
        hit_anything = true
        closest_so_far = temp_rec.t
        rec = temp_rec
      end
    end

    hit_anything
  end
end
