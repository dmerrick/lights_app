$:.push File.expand_path('../lib', __FILE__)
require 'philips_hue/version'

Gem::Specification.new do |s|
  s.name        = 'philips_hue'
  s.version     = PhilipsHue::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.utc.strftime('%Y-%m-%d')
  s.summary     = 'Philips Hue'
  s.description = 'A library to control and query Philips Hue lights'
  s.authors     = ['Dana Merrick']
  s.email       = 'dana.merrick@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/dmerrick/lights_app'
  s.license     = 'MIT'
  s.extra_rdoc_files = ['README.md']
  s.add_runtime_dependency 'httparty', ['>= 0.10.0']
  s.add_runtime_dependency 'json_pure', ['>= 1.6']
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
end
