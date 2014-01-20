module PhilipsHue
  class Light
    autoload :Helpers, "philips_hue/light/helpers"

    include Helpers

    attr_reader :resource_uri, :name, :id

    def initialize(base_uri, id, data)
      @resource_uri = base_uri + "/#{id}"
      @id = id
      @name = data["name"]
    end

    # query full status for single light
    def status
      HTTParty.get(resource_uri)
    end

    # change the state of a light
    # note that colormode will automagically update
    def set(options)
      put "#{resource_uri}/state", options
    end

    # change the name of the light
    def name=(value)
      @name = value
      put resource_uri, name: value
    end

    # a version of the name cleansed to be used as a ruby method name or symbol
    def underscored_name
      name.gsub(" ", "_").gsub(/[^\w]/, "").downcase
    end

    # current state of the light
    def state
      status["state"]
    end

    # determine if the light is on or off
    def on?
      state["on"]
    end

    # turn on the light
    def on!
      set(:on => true)
    end

    # turn off the light
    def off!
      set(:on => false)
    end

    # whether or not the lamp can be seen by the hub
    def reachable?
      state["reachable"]
    end

    # returns the current brightness value
    # can be 0-254 (and 0 is NOT off)
    def bri
      state["bri"]
    end

    # sets the current brightness value
    def bri=(value)
      set(:bri => value)
    end

    # returns the current colormode
    def colormode
      state["colormode"]
    end

    # returns the current hue value
    # used in tandem with "sat" to set the color
    # the 'hue' parameter has the range 0-65535 so represents approximately 182.04*degrees
    def hue
      state["hue"]
    end

    # sets the current hue value
    def hue=(value)
      set(:hue => value)
    end

    # returns the current saturation value
    # used in tandem with "hue" to set the color
    # can be 0-254
    def sat
      state["sat"]
    end

    # sets the current saturation value
    def sat=(value)
      set(:sat => value)
    end

    # returns the current color temperature (white only)
    # in mireds: 154 is the coolest, 500 is the warmest
    # c.p. http://en.wikipedia.org/wiki/Mired
    def ct
      state["ct"]
    end

    # sets the current color temperature
    def ct=(value)
      set(:ct => value)
    end

    # returns the current xy value
    # the color is expressed as an array of co-ordinates in CIE 1931 space
    def xy
      state["xy"]
    end

    # sets the current xy value
    # TODO: consider x() and y() setters/getters
    def xy=(value)
      set(:xy => value)
    end

    # 'select' will flash the lamp once
    # 'lselect' will flash the lamp repeatedly
    # 'none' is the default state
    def alert
      state["alert"]
    end

    # set the alert state
    def alert=(value)
      set(:alert => value)
    end

    #TODO: figure out what this does (and if I can change it)
    def effect
      state["effect"]
    end

    # handy aliases
    alias_method :brightness, :bri
    alias_method :brightness=, :bri=
    alias_method :mode, :colormode
    alias_method :saturation, :sat
    alias_method :saturation=, :sat=
    alias_method :temperature, :ct
    alias_method :temperature=, :ct=
    alias_method :color_temperature, :ct
    alias_method :color_temperature=, :ct=

    # pretty-print the light's status
    def to_s
      pretty_name = @name.to_s.split(/_/).map(&:capitalize).join(" ")
      on_or_off = on? ? "on" : "off"
      reachable = reachable? ? "reachable" : "unreachable"
      "#{pretty_name} is #{on_or_off} and #{reachable}"
    end

    private

    def put(uri, data)
      HTTParty.put(uri, body: data.to_json)
    end
  end
end
