module PhilipsHue
  class Bridge

    # if no app_name is specified, use this one
    DEFAULT_APP_NAME = "lightsapp"

    # creates an app through which to talk to a Philips Hue
    # (new app names must be registered with the bridge)
    #   api_url is the hostname or IP address of the bridge
    #   app_name is used to register with the Hue
    def initialize(api_url, app_name = DEFAULT_APP_NAME)
      @app_name = app_name
      @key = Digest::MD5.hexdigest(@app_name)
      @api_endpoint = "http://#{api_url}/api"
    end

    # provide getter methods for these variables
    attr_reader :app_name, :key, :api_endpoint

    # returns overall system status
    def overview
      request_uri = "#{@api_endpoint}/#{@key}"
      HTTParty.get(request_uri)
    end

    # returns information about the bridge
    def config
      overview["config"]
    end

    # returns the bridge's name
    def name
      config["name"]
    end

    # returns the currently running software version
    def swversion
      config["swversion"]
    end

    # creates a new Light object
    def add_light(light_id, light_name)
      Light.new(light_name, light_id, @api_endpoint, @key)
    end

    # return the lights array or add them if needed
    def lights
      @lights ||= add_all_lights
    end

    # helper method to get light by light_id
    def light(light_id)
      self.lights[light_id.to_i-1]
    end

    # registers your app with the Hue
    # this must be run for every new app name
    def self.register(api_url, app_name = DEFAULT_APP_NAME)
      puts "Press the link button on the Hue..."

      # pretty countdown
      10.downto(1) do |n|
        print n
        sleep 1
        print n == 1 ? "\r#{' '*30}\r" : ", "
      end

      # create a new bridge and submit a special POST request
      new_bridge = self.new(api_url, app_name)
      json_body = { :username => new_bridge.key, :devicetype => new_bridge.app_name}.to_json
      response = HTTParty.post(new_bridge.api_endpoint, :body => json_body)

      # quit if it didn't work (link button wasn't pressed)
      abort "Press link button and try again." if response.first["error"]

      # return the now-registered bridge
      new_bridge
    end

    # a list of all of the registered apps
    def whitelist
      config["whitelist"]
    end

    #TODO: test me
    # returns true if the link button has been pressed recently
    def linkbutton
      config["linkbutton"]
    end

    # returns the IP address
    # n.b. api_endpoint doesn't require an API call
    def ipaddress
      config["ipaddress"]
    end

    # returns true if DHCP is enabled
    def dhcp?
      config["dhcp"]
    end

    # returns the gateway
    def gateway
      config["gateway"]
    end

    # returns the netmask
    def netmask
      config["netmask"]
    end

    # returns the MAC address
    def mac
      config["mac"]
    end

    # returns the proxy address, if set.
    # otherwise returns " "
    def proxyaddress
      config["proxyaddress"]
    end

    # returns the proxy port, if set.
    # otherwise returns 0
    def proxyport
      config["proxyport"]
    end

    # handy aliases
    alias_method :status, :overview
    alias_method :configuration, :config
    alias_method :apps, :whitelist
    alias_method :version, :swversion
    alias_method :ip, :ipaddress

    # human-readable bridge summary
    def to_s
      "Connected to #{self.name} (#{api_endpoint}) via #{app_name}"
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