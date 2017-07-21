Gem::Specification.new do |s|
  s.name        = 'mr_mime'
  s.version     = '0.0.3'
  s.date        = '2016-04-12'
  s.authors     = ['Kyle Edson']
  s.email       = 'rubygems@foraker.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'http://www.github.com/foraker/mr_mime'
  s.license     = 'MIT'
  s.summary     = 'User impersonation for Rails applications'
  s.description = 'MrMime is a Rails engine built to easily add user
  impersonation functionality to your existing Rails application'

  s.files      = Dir['{app,config,lib}/**/*']
  s.test_files = Dir['{spec}/**/*']

  s.add_dependency 'rails', '>= 4.0'

  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rspec', '~> 3.0'
end
