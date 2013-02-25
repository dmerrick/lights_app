require 'httparty'
require 'digest/md5'
require 'json'

require "./lib/light"

class PhillipsHue

  def initialize(app_name, api_url)
    @name = app_name
    @key = Digest::MD5.hexdigest(@name)
    @api_endpoint = "http://#{api_url}/api"

    # auto-incrementing light_id
    @light_id = 0
  end

  # query all lights
  def overview
    request_uri = "#{@api_endpoint}/#{@key}"
    HTTParty.get(request_uri)
  end

  def add_light(light_name)
    @light_id += 1
    Light.new(light_name, @light_id, @api_endpoint, @key)
  end

  #TODO: status(light_id) could be cool here

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
