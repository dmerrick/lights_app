#!/usr/bin/env ruby
# example: flash.rb -l 3 -t 5 -c red -n 3

require 'ostruct'
require 'optparse'

require_relative '../philips_hue'

# set default values here
colors = { "red"    => [0.6446, 0.3289],
           "blue"   => [0.1727, 0.0512],
           "green"  => [0.4034, 0.5067],
           "yellow" => [0.4447, 0.4918]}

options = OpenStruct.new
options.light_id = 1
options.delay    = 1
options.repeat   = 1
options.color    = colors["red"]
options.app_name = "lightsapp"
options.api_url  = "192.168.1.14"

OptionParser.new do |opts|
  opts.banner = "Usage: flash.rb [options]"
  opts.on("-l [id]", Integer, "Light to flash") do |id|
    options.light_id = id
  end
  opts.on("-c [color]", "The color to flash") do |color|
    options.color = colors[color]
  end
  opts.on("-t [secs]", Float, "Length of flashes in seconds") do |length|
    options.delay = length
  end
  opts.on("-n [number]", Integer, "Repeat [number] times") do |num|
    options.repeat = num
  end
  opts.on("--app [app_name]", "The name of the registered app") do |app|
    options.app_name = app
  end
  opts.on("--api [url]", "The address of the Hue hub") do |api|
    options.api_url = api
  end
end.parse!

# get everything ready...
hue = PhilipsHue.new(options.app_name, options.api_url)
light = hue.light(options.light_id)
old_xy = light.xy

# ...make magic happen
options.repeat.times do
  # flash!
  light.flash(options.color, :delay => options.delay, :old_xy => old_xy)
  sleep options.delay
end
