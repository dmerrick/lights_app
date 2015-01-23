def enhance_color(normalized)
  if normalized > 0.04045
    ((normalized + 0.055) / (1.0 + 0.055))**2.4
  else
    normalized / 12.92
  end
end

module PhilipsHue::Helpers

  def rgb(r, g, b)
    r_final = enhance_color(r / 255.0)
    g_final = enhance_color(g / 255.0)
    b_final = enhance_color(b / 255.0)
    x = r_final * 0.649926 + g_final * 0.103455 + b_final * 0.197109
    y = r_final * 0.234327 + g_final * 0.743075 + b_final * 0.022598
    z = r_final * 0.000000 + g_final * 0.053077 + b_final * 1.035763
    if x + y + z == 0
      self.xy = [0, 0]
    else
      x_final = x / (x + y + z)
      y_final = y / (x + y + z)
      self.xy = [x_final, y_final]
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

  # default scenes from Hue app
  def reading                  
    self.xy = [0.4448, 0.4066] 
    self.bri = 240             
  end                          

  def relax                    
    self.xy = [0.5119, 0.4147] 
    self.bri = 144             
  end                          

  def energize                 
    self.xy = [0.3151, 0.3252] 
    self.bri = 203             
  end                          

  def concentrate              
    self.xy = [0.368, 0.3686]  
    self.bri = 219             
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
