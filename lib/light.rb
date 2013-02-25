class Light

  def initialize(light_name, light_id, api_endpoint, key)
    @name = light_name
    @id = light_id
    @api_endpoint = api_endpoint
    @key = key
  end

  # query a single light
  def status
    request_uri = "#{@api_endpoint}/#{@key}/lights/#{@id}"
    HTTParty.get(request_uri)
  end

  def set(options)
    json_body = options.to_json
    request_uri = "#{@api_endpoint}/#{@key}/lights/#{@id}/state"
    HTTParty.put(request_uri, :body => json_body)
  end

  def state
    status["state"]
  end

  def on?
    state["on"]
  end

  def reachable?
    state["reachable"]
  end

  def hue
    state["hue"]
  end

  def hue=(value)
    set(:hue => value)
  end

  def sat
    state["sat"]
  end

  def sat=(value)
    set(:sat => value)
  end

  def ct
    state["ct"]
  end

  def ct=(value)
    set(:ct => value)
  end

  def bri
    state["bri"]
  end

  def bri=(value)
    set(:bri => value)
  end

  # n.b. colormode= doesnt seem to work
  def colormode
    state["colormode"]
  end

  def xy
    state["xy"]
  end

  def xy=(value)
    set(:xy => value)
  end

  # TODO: consider x() and y() setters/getters

  def red
    self.xy = [0.6446, 0.3289]
  end

  def green
    self.xy = [0.4034, 0.5067]
  end

  def blue
    self.xy = [0.1727, 0.0512]
  end

  def yellow
    self.xy = [0.4447, 0.4918]
  end

  def to_s
    pretty_name = @name.to_s.split(/_/).map(&:capitalize).join(" ")
    on_or_off = on? ? "on" : "off"
    reachable = reachable? ? "reachable" : "not reachable"
    "#{pretty_name} is #{on_or_off} and #{reachable}"
  end
end

__END__
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
