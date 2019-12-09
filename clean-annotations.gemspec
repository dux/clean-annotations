version  = File.read File.expand_path '.version', File.dirname(__FILE__)
gem_name = 'clean-annotations'

Gem::Specification.new gem_name, version do |gem|
  gem.summary     = 'Annotate ruby methods and classes, define callbacks'
  gem.description = 'Define annotatable attribute names and assign them to methods or classes, add callbacks to non-Rails classes. Void of dependencies.'
  gem.authors     = ["Dino Reic"]
  gem.email       = 'reic.dino@gmail.com'
  gem.files       = Dir['./lib/**/*.rb']+['./.version']
  gem.homepage    = 'https://github.com/dux/%s' % gem_name
  gem.license     = 'MIT'
end