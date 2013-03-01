#!/usr/bin/env ruby
# example: flash.rb -l 3 -t 5 -c red -n 3

require 'rubygems'
require 'ostruct'
require 'optparse'
require 'philips_hue'

# set default values here
colors = { "red"    => [0.6446, 0.3289],
           "blue"   => [0.1727, 0.0512],
           "green"  => [0.4034, 0.5067],
           "yellow" => [0.4447, 0.4918]}

options = OpenStruct.new
options.light_id = 1
options.delay    = 1
options.repeat   = 1
options.crazy    = false
options.color    = colors["red"]
options.app_name = "lightsapp"
options.api_url  = "192.168.1.14"

OptionParser.new do |opts|
  opts.banner = "Usage: flash.rb [options]"
  opts.on("-a [app_name]","--app [app_name]", "The name of the registered app") do |app|
    options.app_name = app
  end
  opts.on("-b [addr]","--bridge [addr]", "The address of the Hue bridge") do |api|
    options.api_url = api
  end
  opts.on("-l [id]", "--light [id]", Integer, "Light to flash") do |id|
    options.light_id = id
  end
  opts.on("-c [color]", "--color [color]", "The color to flash") do |color|
    options.color = colors[color]
  end
  opts.on("-t [secs]", "--length [secs]", Float, "Length of flashes in seconds") do |length|
    options.delay = length
  end
  opts.on("-n [num]", "--repeat [num]", Integer, "Repeat [num] times") do |num|
    options.repeat = num
  end
  opts.on("-z", "--crazymode", "Enable crazymode") do |crazy|
    options.crazy = crazy
  end
end.parse!

# get everything ready...
hue = PhilipsHue::Bridge.new(options.app_name, options.api_url)
light = hue.light(options.light_id)

# ...make magic happen
options.repeat.times do |n|
  light.flash(options.color, options.delay, options.crazy)
  sleep options.delay unless n == options.repeat-1
end
