require 'httparty'
require 'digest/md5'
require 'json'

# requires ruby 1.9 or greater
require_relative "lib/light"

class PhilipsHue

  # creates a new app to talk to a Philips Hue
  #   app_name is used to register with the Hue
  #   api_url is the hostname/IP address of the Hue hockeypuck
  def initialize(app_name, api_url)
    @name = app_name
    @key = Digest::MD5.hexdigest(@name)
    @api_endpoint = "http://#{api_url}/api"

    # auto-incrementing light_id
    @light_id = 0
  end

  # returns overall system status as JSON
  def overview
    request_uri = "#{@api_endpoint}/#{@key}"
    HTTParty.get(request_uri)
  end

  # creates a new Light object using auto-incrementing light_id
  def add_light(light_name)
    @light_id += 1
    Light.new(light_name, @light_id, @api_endpoint, @key)
  end

  #TODO: status(light_id) could be cool here

  # registers your app with the Hue
  # this must be run for every unique app name
  # FIXME: this needs to be more adequately tested
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

end
