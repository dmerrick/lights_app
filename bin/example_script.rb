#!/usr/bin/env ruby
require 'awesome_print'

# requires ruby 1.9 or greater
require_relative '../philips_hue'

# put your customizations here
hue = PhilipsHue.new("lightsapp", "192.168.1.14")
#hue.register!

# assign in order by their light_id
front_right = hue.add_light(:front_right)
back_right  = hue.add_light(:back_right)
front_left  = hue.add_light(:front_left)

#ap hue.overview
#ap front_right.state
#puts front_right.colormode
#puts front_right.xy
#front_right.xy = [0.6446, 0.3289]
puts front_right

# loop pretty colors
looping = true
loop do

  front_left.red
  front_right.green
  back_right.blue

  sleep 1

  front_left.blue
  front_right.blue
  back_right.yellow

  sleep 1

  front_left.yellow
  front_right.red
  back_right.red

  sleep 1

end if looping
