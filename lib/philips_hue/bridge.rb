module PhilipsHue
  class Bridge

    # creates an app through which to talk to a Philips Hue
    # (new app names must be registered with the bridge)
    #   app_name is used to register with the Hue
    #   api_url is the hostname/IP address of the bridge
    def initialize(app_name, api_url)
      @app_name = app_name
      @key = Digest::MD5.hexdigest(@app_name)
      @api_endpoint = "http://#{api_url}/api"
      @lights = add_all_lights
    end

    # provide getter methods for these variables
    attr_reader :app_name, :key, :api_endpoint, :lights

    # returns overall system status as JSON
    def overview
      request_uri = "#{@api_endpoint}/#{@key}"
      HTTParty.get(request_uri)
    end

    # creates a new Light object
    def add_light(light_id, light_name)
      Light.new(light_name, light_id, @api_endpoint, @key)
    end

    # helper method to get light by light_id
    def light(light_id)
      @lights[light_id.to_i-1]
    end

    # registers your app with the Hue
    # this must be run for every unique app name
    # FIXME: this needs to be more adequately tested
    def register!
      puts "Press the link button on the Hue..."
      sleep 10
      json_body = {:username => @key, :devicetype => @app_name}.to_json
      response = HTTParty.post(@api_endpoint, :body => json_body)

      if response.first["error"] # should be response.code
        puts "Press link button and try again."
        exit
      else
        return response
      end
    end

    private
    # loop through the available lights and make corresponding objects
    def add_all_lights
      all_lights = []
      overview["lights"].each do |id, light|
        all_lights << add_light(id.to_i, light["name"])
      end
      all_lights
    end

  end
end