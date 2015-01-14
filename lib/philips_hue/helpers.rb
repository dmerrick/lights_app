def EnhanceColor(normalized)
normalized > 0.04045 ? ((normalized + 0.055) / (1.0 + 0.055)) ** 2.4 : normalized / 12.92
end

module PhilipsHue::Helpers


def RGB(r, g, b)
  rNorm = r / 255.0
  gNorm = g / 255.0
  bNorm = b / 255.0

  rFinal = EnhanceColor(rNorm)
  gFinal = EnhanceColor(gNorm)
  bFinal = EnhanceColor(bNorm)

  x = rFinal * 0.649926 + gFinal * 0.103455 + bFinal * 0.197109
  y = rFinal * 0.234327 + gFinal * 0.743075 + bFinal * 0.022598
  z = rFinal * 0.000000 + gFinal * 0.053077 + bFinal * 1.035763

    if x + y + z == 0
      self.xy = [0,0]
    else
      xFinal = x / (x + y + z)
      yFinal = y / (x + y + z)
      self.xy = [xFinal, yFinal]
    end
  end


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

  def white
    self.xy = [0.3127301082804434, 0.3290198826715099]
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

