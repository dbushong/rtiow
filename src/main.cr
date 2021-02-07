require "option_parser"
require "./render"

image_width = 1200
image_height = 675
samples_per_pixel = 500
max_depth = 50
scene_name = "cover"

OptionParser.parse do |parser|
  parser.banner = "usage: inOneWeekend [options]"
  parser.on(
    "-w WIDTH",
    "--width=WIDTH",
    "Width in pixels (default: #{image_width})"
  ) { |w| image_width = w.to_i }
  parser.on(
    "-h HEIGHT",
    "--height=HEIGHT",
    "Height in pixels (default: #{image_height})"
  ) { |h| image_height = h.to_i }
  parser.on(
    "-p SAMPLES",
    "--samples=SAMPLES",
    "Number of samples per pixel (default: #{samples_per_pixel})"
  ) { |p| samples_per_pixel = p.to_i }
  parser.on(
    "-s SCENE",
    "--scene=SCENE",
    "Scene to render (default: #{scene_name})"
  ) { |s| scene_name = s }
  parser.on(
    "-d STEPS",
    "--max-depth=STEPS",
    "Max steps depth calcs will do (default: #{max_depth})"
  ) { |d| max_depth = d.to_i }
  parser.on("--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option"
    STDERR.puts parser
    exit 1
  end
  parser.missing_option do |flag|
    STDERR.puts "ERROR: #{flag}: missing required argument"
    STDERR.puts parser
    exit 1
  end
end

render(image_width, image_height, samples_per_pixel, max_depth, scene_name)
