#!/usr/bin/env ruby
require 'philips_hue'

hue = PhilipsHue::Bridge.new("lightsapp", "192.168.1.14")
light1, light2, light3 = hue.lights

light1.off!
light2.off!
light3.off!
