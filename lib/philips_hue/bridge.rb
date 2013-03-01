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
    end

    # provide getter methods for these variables
    attr_reader :app_name, :key, :api_endpoint

    # returns overall system status as JSON
    def overview
      request_uri = "#{@api_endpoint}/#{@key}"
      HTTParty.get(request_uri)
    end

    # creates a new Light object
    def add_light(light_id, light_name)
      Light.new(light_name, light_id, @api_endpoint, @key)
    end

    # return the lights array or add them it if needed
    def lights
      @lights ||= add_all_lights
    end

    # helper method to get light by light_id
    def light(light_id)
      self.lights[light_id.to_i-1]
    end

    # registers your app with the Hue
    # this must be run for every new app name
    def self.register(app_name, api_url)
      puts "Press the link button on the Hue..."

      # pretty countdown
      10.downto(1) do |n|
        print n
        sleep 1
        print n == 1 ? "\r#{' '*30}\r" : ", "
      end

      # create a new bridge and submit a special POST request
      new_bridge = self.new(app_name, api_url)
      json_body = { :username => new_bridge.key, :devicetype => new_bridge.app_name}.to_json
      response = HTTParty.post(new_bridge.api_endpoint, :body => json_body)

      # quit if it didn't work (link button wasn't pressed)
      abort "Press link button and try again." if response.first["error"]

      # return the now-registered bridge
      new_bridge
    end

    # handy alias
    alias_method :status, :overview

    # human-readable bridge summary
    def to_s
      "#{app_name}: #{api_endpoint}"
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