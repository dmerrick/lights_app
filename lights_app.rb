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

    if response.first["error"]
      puts "Press link button and try again."
      exit
    else
      return response
    end
  end

  # query all lights
  def overview
    HTTParty.get("#{@api_endpoint}/#{@key}")
  end

  # query a single light
  def status(light_id)
    HTTParty.get("#{@api_endpoint}/#{@key}/lights/#{light_id}")
  end

end

if $0 == __FILE__
  # put your customizations here
  app = LightsApp.new("lightsapp", "192.168.1.14")

  # I've commented this out because I already registered
  #app.register!

  # human-readable ids
  front_right = 1
  back_right  = 2
  front_left  = 3

  require 'awesome_print'
  ap app.overview
  #ap app.status front_left
end


__END__
# register worked:
# => [{"success"=>{"username"=>"5a90e47a2ac90131ace46cce377bdc64"}}]

# register failed (press link button):
# => [{"error"=>
#     {"address"=>"", "type"=>101, "description"=>"link button not pressed"}}]
