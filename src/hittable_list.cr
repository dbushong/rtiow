require "./hittable"

class HittableList < Hittable
  def initialize
    @objects = [] of Hittable
  end

  def <<(obj : Hittable)
    @objects << obj
    self
  end

  def clear
    @objects.clear
  end

  def hit(r : Ray, t_min : Float64, t_max : Float64) : HitRecord | Nil
    closest_so_far = t_max
    rec = nil : HitRecord | Nil

    @objects.each do |object|
      temp_rec = object.hit(r, t_min, closest_so_far)
      if temp_rec
        closest_so_far = temp_rec.t
        rec = temp_rec
      end
    end

    rec
  end

  def material
    raise "Should never be checking material of list"
  end
end
