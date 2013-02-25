require 'httparty'

class Light

  def initialize(light_name, light_id, api_endpoint, key)
    @name = light_name
    @id = light_id
    @api_endpoint = api_endpoint
    @key = key
  end

  # query full status for single light
  def status
    request_uri = "#{@api_endpoint}/#{@key}/lights/#{@id}"
    HTTParty.get(request_uri)
  end

  # change the state of a light
  # note that colormode will automagically update
  def set(options)
    json_body = options.to_json
    request_uri = "#{@api_endpoint}/#{@key}/lights/#{@id}/state"
    HTTParty.put(request_uri, :body => json_body)
  end

  # current state of the light
  def state
    status["state"]
  end

  #TODO: can this be set-able?
  def on?
    state["on"]
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

  #TODO: I have not tested this at all
  # 'select' will flash the lamp once
  # 'lselect' will flash the lamp repeatedly
  def alert
    state["alert"]
  end

  #TODO: figure out what this does (and if I can change it)
  def effect
    state["effect"]
  end

  #TODO: add transitiontime()
  # if specified (in 1/10s), will cause the light to change over the time set
  # if set to 0 will result in a 'snap' and bypass the usual soft fade

  # cheap helper method
  def red
    self.xy = [0.6446, 0.3289]
  end

  # cheap helper method
  def green
    self.xy = [0.4034, 0.5067]
  end

  # cheap helper method
  def blue
    self.xy = [0.1727, 0.0512]
  end

  # cheap helper method
  def yellow
    self.xy = [0.4447, 0.4918]
  end

  # pretty-print the light's status
  def to_s
    pretty_name = @name.to_s.split(/_/).map(&:capitalize).join(" ")
    on_or_off = on? ? "on" : "off"
    reachable = reachable? ? "reachable" : "unreachable"
    "#{pretty_name} is #{on_or_off} and #{reachable}"
  end
end

__END__
example state() return value:
{
           "on" => true,
          "bri" => 254,
          "hue" => 12519,
          "sat" => 225,
           "xy" => [
        [0] 0.5261,
        [1] 0.4132
    ],
           "ct" => 497,
        "alert" => "none",
       "effect" => "none",
    "colormode" => "ct",
    "reachable" => true
}
