Gem::Specification.new do |s|
  s.name            = 'rusen'
  s.version         = '0.0.2'
  s.date            = '2012-01-25'
  s.platform        = Gem::Platform::RUBY
  s.authors         = ['Adrian Gomez']
  s.summary         = 'RUby Simple Exception Notification'
  s.description     = 'RUby Simple Exception Notification (a.k.a. rusen) as it names indicates is a
                       simple exception notification for ruby.'
  s.email           = 'adri4n.gomez@gmail.com'
  s.homepage        = 'https://github.com/Moove-it/rusen'

  s.files           = Dir.glob('{lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)

  s.files           = Dir.glob('{lib}/**/*')

  s.add_dependency('pony')

  s.add_development_dependency('rspec')
  s.add_development_dependency('simplecov')
end