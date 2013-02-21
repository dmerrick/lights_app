#!/usr/bin/env ruby

require 'httparty'
require 'digest/md5'
require 'json'

class LightsApp

  def initialize(name, api_url)
    @name = name
    @key = Digest::MD5.hexdigest(@name)
    @api_endpoint = "http://#{api_url}/api"
  end

  def register!
    puts "Press the link button on the Hue..."
    sleep 10
    json_body = {:username => @key, :devicetype => @name}.to_json
    response = HTTParty.post(@api_endpoint, :body => json_body)

    if response.first["error"] # should be response.code
      puts "Press link button and try again."
      exit
    else
      return response
    end
  end

  # query all lights
  def overview
    request_uri = "#{@api_endpoint}/#{@key}"
    HTTParty.get(request_uri)
  end

  # query a single light
  def status(light_id)
    request_uri = "#{@api_endpoint}/#{@key}/lights/#{light_id}"
    HTTParty.get(request_uri)
  end

  def set_light(light_id, options)
    json_body = options.to_json
    request_uri = "#{@api_endpoint}/#{@key}/lights/#{light_id}/state"
    HTTParty.put(request_uri, :body => json_body)
  end

end

if $0 == __FILE__
  # put your customizations here
  app = LightsApp.new("lightsapp", "192.168.1.14")

  # register the script with the Hue
  #app.register!

  # human-readable ids
  front_right = 1
  back_right  = 2
  front_left  = 3

  #require 'awesome_print'
  #ap app.overview
  #ap app.status front_left

  # flash the lights red and green
  while true
    app.set_light(front_left,  :hue => 25000, :sat => 254)
    app.set_light(front_right, :hue => 25000, :sat => 254)
    app.set_light(back_right,  :ct  => 500,   :bri => 254)
    sleep 1
    app.set_light(front_left,  :ct  => 500,   :bri => 254)
    app.set_light(front_right, :ct  => 500,   :bri => 254)
    app.set_light(back_right,  :hue => 25000, :sat => 254)
    sleep 1
  end

end


__END__
# api_url can be found at:
# https://www.meethue.com/en-US/user/preferencessmartbridge

# extra details about hacking Hues:
# http://rsmck.co.uk/hue

# register worked response:
# => [{"success"=>{"username"=>"5a90e47a2ac90131ace46cce377bdc64"}}]

# register failed response (press link button):
# => [{"error"=>
#     {"address"=>"", "type"=>101, "description"=>"link button not pressed"}}]
