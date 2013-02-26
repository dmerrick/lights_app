require File.expand_path("../lib/philips_hue/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'philips_hue'
  s.version     = PhilipsHue::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2013-02-26'
  s.summary     = 'Philips Hue'
  s.description = 'A library to control and query Philips Hue lights'
  s.authors     = ['Dana Merrick']
  s.email       = 'dana.merrick@gmail.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "*.md"]
  s.homepage    = 'https://github.com/dmerrick/lights_app'
  s.extra_rdoc_files = ['README.md']
  s.add_runtime_dependency "httparty", [">= 0.10.0"]
  #s.post_install_message = ""
end
