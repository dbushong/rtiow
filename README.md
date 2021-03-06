# Ray Tracing in One Weekend in Crystal (Lang)

This is my first [crystal][cl] program; implementing the simple raytracer from
this excellent book:

https://raytracing.github.io/books/RayTracingInOneWeekend.html

(version 3.2.3)

![render](out.jpg)

## Git Branches

- `main` - the latest whatever I'm working on
- `in-one-weekend` - the code as of the end of the first book

## Building & Running

```
$ cd rtiow
$ shards build --release
$ ./bin/inOneWeekend --help
```

## Tasks

- [x] Build naïve functionality, writing things basically in rubyish Crystal
- [x] Do some of the tips from the Crystal "Performance" page
- [x] Reorganize as a well-structured crystal app repo
- [x] Add options processing for render parameters (and scenes?)
- [ ] Port "Raytracing: The Next Week"
- [ ] Add tests
- [ ] Add forking(?) parallelism to use more threads for parallel scanlines

## Notes

I found Crystal surprisingly easy to work with. I have no point of reference
for performance (I should download the C++ baseline for comparison), but it
seems pretty zippy. The compiler errors are very helpful and clear.

Update: performance is amazing, particularly for how high-level the code
writing can be

Mac tip:

```
$ crystal run --release src/main.cr -- -w 75 -h 75 -s 10 > out.ppm \
  && qlmanage -p out.ppm >/dev/null 2>&1
```

## Performance

All times are for rendering the cover graphic:

- at 1200x675 resolution
- with 10 samples per pixel
- on a 2.3 GHz 8-core Intel Core i9 in a 2019 MacBook Pro

### Results

- Baseline C++ compiled with defaults from raytracing.github.io as of
  2021-02-03:
  ```
  ./build/inOneWeekend > out.ppm  401.43s user 0.42s system 99% cpu 6:42.37 total
  ```
- Naïve Crystal version with no structs or other code optimizations, but
  built with `--release`:
  ```
  ./inOneWeekend > out.ppm  313.17s user 677.08s system 307% cpu 5:21.90 total
  ```
- Replaced key `class` keywords with `struct` (5 mins work):
  ```
  ./inOneWeekend > out.ppm  41.70s user 2.08s system 99% cpu 43.894 total
  ```

One more data point: as above but with 500 samples-per-pixel took 34m47s

[cl]: https://crystal-lang.org/
