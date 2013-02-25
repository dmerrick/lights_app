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


### Adding Lights

To add lights, you can use `PhilipsHue#add_light`.

* You must specify a name for the light, which can be either a String or a Symbol. Example: `"living room table"`, `:front_right`, `"kitchen ceiling"`
* You should add the lights in order by their ID. See the Hue Community site or the mobile app for the correct order.
 
Full example:
```ruby
      front_right = hue.add_light(:front_right) # assumes light_id #1
      back_right  = hue.add_light(:back_right)  # assumes light_id #2
      front_left  = hue.add_light(:front_left)  # assumes light_id #3
      # etc.
```

### See Also
* [http://rsmck.co.uk/hue](http://rsmck.co.uk/hue)

