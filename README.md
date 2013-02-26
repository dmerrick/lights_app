## Lights App

This is a library for accessing and controlling your [Philips Hue](http://www.meethue.com/) lights using Ruby.

#### TL;DR:

Check out [bin/example_script.rb](https://github.com/dmerrick/lights_app/blob/master/bin/example_script.rb) for an example of how to use this project and what kind of things you can do.


### Registering a New App

You need two things to connect with your Hue, a name for your app and the IP address of the white Hue hockeypuck.

* The IP address can be found on the Hue Community site. Login, [go here](https://www.meethue.com/en-US/user/preferencessmartbridge), click "Show me more," and find the IP under "Internal IP address." Example: `"192.168.1.14"`
* The app name can be anything you like. You must register your app with the Hue by running `PhilipsHue#register!` and pressing the button on the hockeypuck. You must do this again for every new app name you create. Example: `"my light app"`

Full example:
```ruby
  hue = PhilipsHue.new("my light app", "192.168.1.14")
  hue.register!
```

### Getting the State of a Light

There are many available status options in the `Light` class.

```ruby
  light1 = hue.lights.first
  puts light1.state # returns JSON
  puts light1.colormode
  puts light1.xy
  puts light1
  # => "Front right is on and reachable"
```


### Changing the Color of a Light

To change the state of a light, simply modify the value of one of the state parameters. For example:

```ruby
  light1.xy  = [0.6446, 0.3289]
  light1.ct  = 200   # note that the colormode changes
  light1.hue = 25000 # colormode changes again
  # etc.
```

#### Default Colors

Some default color methods are provided, for example:

```ruby
  light1.blue
  light2.red
  light3.green
```


### See Also
* [Official Philips Hue site](https://www.meethue.com/en-US)
* [rsmck's hacking guide](http://rsmck.co.uk/hue)
* [Hue hackers' community site](http://www.everyhue.com/)
* [Thorough API docs](http://blog.ef.net/2012/11/02/philips-hue-api.html)
