require 'httparty'
require 'digest/md5'
require 'json'

require 'philips_hue/bridge'
require 'philips_hue/light'

module PhilipsHue
  # make this module a singleton
  extend self
end
