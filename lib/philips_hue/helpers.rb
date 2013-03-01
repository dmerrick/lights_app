module PhilipsHue::Helpers

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

  # flash once
  def blip
    self.alert = "select"
  end

  # flash repeatedly
  def blink
    self.alert = "lselect"
  end

  # flash a specified color
  #  xy is the color to use
  #  delay is the length of the flash (in seconds)
  #  crazymode causes the light to blink during the flash
  def flash(xy, delay = 1, crazymode = false)
    # use state() and set() to minimize number of API calls
    original = self.state

    # turns the light on and maxes brightness too
    flash_state = {
      :xy  => xy,
      :on  => true,
      :bri => 255
    }

    # blink instead if the color is not going to change
    if xy == original["xy"] && original["colormode"] == "xy"
      flash_state["alert"] = "select"
    end

    # blink repeatedly if crazymode flag is set
    # (works best for delay >2 seconds)
    flash_state["alert"] = "lselect" if crazymode

    # the state to which to restore
    # (color gets set after)
    final_state = {
      :on => original["on"],
      :bri => original["bri"],
      :alert => original["alert"]
    }

    # smartly return to the original color
    case original["colormode"]
    when "xy"
      final_state[:xy]  = original["xy"]
    when "ct"
      final_state[:ct]  = original["ct"]
    when "hs"
      final_state[:hue] = original["hue"]
    end

    # flash!
    set(flash_state)
    # zzz...
    sleep delay
    # restore the light to its original state
    set(final_state)
  end
end
