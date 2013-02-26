#!/usr/bin/env ruby
# this is a basic example of what you can do with this library
require_relative '../philips_hue'

# set up your hue app here
hue = PhilipsHue.new("lightsapp", "192.168.1.14")

# assign each light to a variable
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
