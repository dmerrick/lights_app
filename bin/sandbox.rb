#!/usr/bin/env ruby
require 'pp'
require 'awesome_print'
require 'pry'
require_relative '../philips_hue'

hue = PhilipsHue.new("lightsapp", "192.168.1.14")
a, b, c = hue.lights

# open an interactive session
binding.pry
