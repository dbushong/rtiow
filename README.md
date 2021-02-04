# Ray Tracing in One Weekend in Crystal (Lang)

This is my first crystal program; implementing the simple raytracer from
this excellent book:

https://raytracing.github.io/books/RayTracingInOneWeekend.html

## TODO

- [x] Build naïve functionality, writing things basically in rubyish Crystal
- [ ] Do some of the tips from the Crystal "Performance" page
- [ ] Add forking(?) parallelism to use more threads for parallel scanlines

## Notes

I found Crystal surprisingly easy to work with. I have no point of reference
for performance (I should download the C++ baseline for comparison), but it
seems pretty zippy. The compiler errors are very helpful and clear.

## Performance

All times are for rendering the cover graphic:

- at 1200x800 resolution
- with 500 samples per pixel
- on a 2.3 GHz 8-core Intel Core i9 in a 2019 MacBook Pro

### Results

- Naïve version with lots of `class` and no optimizations, but running with
  `--release`: 2.5 hours to render
