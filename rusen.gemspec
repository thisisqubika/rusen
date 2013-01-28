Gem::Specification.new do |s|
  s.name            = 'rusen'
  s.version         = '0.0.1'
  s.date            = '2012-01-25'
  s.platform        = Gem::Platform::RUBY
  s.authors         = ['Adrian Gomez']
  s.summary         = 'Ruby Simple EXception Notification'
  s.description     = 'Ruby Simple EXception Notification (a.k.a. rusen) as it names indicates is a
                       simple exception notification for ruby.'
  s.email           = 'adri4n.gomez@gmail.com'
  #s.homepage        = 'http://rubygems.org/gems/hola'

  s.files           = Dir.glob('{lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)

  s.files           = Dir.glob('{lib}/**/*')

  s.add_dependency('pony')

  s.add_development_dependency('rspec')
  s.add_development_dependency('simplecov')
end