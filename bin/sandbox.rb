#!/usr/bin/env ruby
require 'pp'
require 'awesome_print'
require 'pry'
require 'philips_hue'

hue = PhilipsHue::Bridge.new("lightsapp", "192.168.1.14")
a, b, c = hue.lights

# open an interactive session
binding.pry
