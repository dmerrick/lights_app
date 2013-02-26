Gem::Specification.new do |s|
  s.name        = 'philips_hue'
  s.version     = '0.1.1'
  s.date        = '2013-02-26'
  s.summary     = 'Philips Hue'
  s.description = 'A library to control and query Philips Hue lights'
  s.authors     = ['Dana Merrick']
  s.email       = 'dana.merrick@gmail.com'
  s.files       = Dir["{lib}/**/*.rb", "*.md"]
  s.homepage    = 'https://github.com/dmerrick/lights_app'
  s.add_runtime_dependency "httparty", [">= 0.10.0"]
end
