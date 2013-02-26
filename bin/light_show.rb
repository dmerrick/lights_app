#!/usr/bin/env ruby
require 'rubygems'
require 'philips_hue'

hue = PhilipsHue::Bridge.new("lightsapp", "192.168.1.14")
light1, light2, light3 = hue.lights

# print status of light1
puts light1

# true if we want to have a colorful party
looping = true

# loop pretty colors
loop do

  light1.red
  light2.green
  light3.blue

  sleep 1

  light1.blue
  light2.blue
  light3.yellow

  sleep 1

  light1.yellow
  light2.red
  light3.red

  sleep 1

end if looping
