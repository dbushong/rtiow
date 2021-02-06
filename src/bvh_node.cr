require "./hittable"
require "./hittable_list"

class BVHNode < Hittable
  def initialize(
    src_objects : Array(Hittable),
    start : Int32,
    _end : Int32,
    time0 : Float64,
    time1 : Float64
  )
    objects = src_objects
    comparator = ->box_compare(FIXME).partial(rand(0..2))
    object_span = _end - start

    if object_span == 1
      left = right = objects[start]
    elsif object_span == 2
      left = objects[start + 1]
      right = objects[start]
      if comparator.call(objects[start], objects[start + 1]) == -1
        left, right = right_left
      end
    else
      objects[start, object_span] = objects[start, object_span].sort(&comparator)

      mid = start + object_span / 2
      left = BVHNode.new(objects, start, mid, time0, time1)
      right = BVHNode.new(objects, mid, end, time0, time1)
    end

    box_left = left.bounding_box(time0, time1)
    box_right = right.bounding_box(time0, time1)

    raise "No bounding box in BVHNode box_compare" unless box_left && box_right

    @box = box_left.surrounding_box(box_right)
  end

  def hit(r : Ray, t_min : Float64, t_max : Float64) : HitRecord?
    return nil unless @box.hit(r, t_min, t_max)
    hit_left = @left.hit(r, t_min, t_max)
    hit_right = @right.hit(r, t_min, hit_left ? hit_left.t : t_max)
    hit_left || hit_right
  end

  def bounding_box(time0 : Float64, time1 : Float64) : AaBb
    @box
  end

  def box_compare(axis : Int32, a : Hittable, b : Hittable) : Int32
    box_a = a.bounding_box(0, 0)
    box_b = b.bounding_box(0, 0)

    raise "No bounding box in BVHNode box_compare" unless box_a && box_b

    box_a.min[axis] <=> box_b.min[axis]
  end
end
