#!/usr/bin/env ruby

require 'optparse'

require 'pp'
require 'awesome_print'
require 'pry'

require_relative '../philips_hue'

# set default values here
options = OpenStruct.new
options.light_id = 1
#options.color    = "red"
options.delay    = 1
options.number   = 1

OptionParser.new do |opts|
  opts.banner = "Usage: flash.rb [options]"

  opts.on("-l [id]", Integer, "Light to flash") do |l|
    options.light_id = l
  end

  #opts.on("-c", "--color", "Run verbosely") do |c|
  #  options.color = c
  #end

  opts.on("-t [secs]", Float, "Length of flashes in seconds") do |t|
    options.delay = t
  end

  opts.on("-n [number]", Integer, "Flash [number] times") do |n|
    options.number = n
  end
end.parse!

hue = PhilipsHue.new("lightsapp", "192.168.1.14")
light = hue.light(options.light_id)
old_xy = light.xy

options.number.times do
  # flash!
  light.red
  sleep options.delay
  light.xy = old_xy
end
