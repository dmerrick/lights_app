#!/usr/bin/env ruby
# example: flash.rb -l 3 -t 5 -c red -n 3

require 'optparse'

require_relative '../philips_hue'

# set default values here
colors = { "red"    => [0.6446, 0.3289],
           "blue"   => [0.1727, 0.0512],
           "green"  => [0.4034, 0.5067],
           "yellow" => [0.4447, 0.4918]}

options = OpenStruct.new
options.light_id = 1
options.color    = colors["red"]
options.delay    = 1
options.repeat   = 1

OptionParser.new do |opts|
  opts.banner = "Usage: flash.rb [options]"

  opts.on("-l [id]", Integer, "Light to flash") do |l|
    options.light_id = l
  end

  opts.on("-c [color]", "The color to flash") do |c|
    options.color = colors[c]
  end

  opts.on("-t [secs]", Float, "Length of flashes in seconds") do |t|
    options.delay = t
  end

  opts.on("-n [number]", Integer, "Repeat [number] times") do |n|
    options.repeat = n
  end
end.parse!

hue = PhilipsHue.new("lightsapp", "192.168.1.14")
light = hue.light(options.light_id)
old_xy = light.xy

options.repeat.times do
  # flash!
  light.flash(options.color, :delay => options.delay, :old_xy => old_xy)
  sleep options.delay
end
