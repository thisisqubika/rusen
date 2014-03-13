# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rusen/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = 'rusen'
  s.version         = Rusen::VERSION
  s.platform        = Gem::Platform::RUBY
  s.authors         = ['Adrian Gomez']
  s.summary         = 'RUby Simple Exception Notification'
  s.description     = 'RUby Simple Exception Notification (a.k.a. rusen) as it names indicates is a
                       simple exception notification for ruby.'
  s.email           = 'adri4n.gomez@gmail.com'
  s.homepage        = 'https://github.com/Moove-it/rusen'
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.licenses = ["MIT"]

  s.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md CHANGELOG.md Rakefile)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.extra_rdoc_files = [
    "CHANGELOG.md",
    "LICENSE",
    "README.md"
  ]


  s.add_development_dependency('log4r')
  s.add_development_dependency('pony')
  s.add_development_dependency('mail')
  s.add_development_dependency('rspec')
  s.add_development_dependency('shoulda', '< 3.6')
  s.add_development_dependency('shoulda-matchers', '< 1.6')
  s.add_development_dependency('simplecov')
  s.add_development_dependency(%q<reek>, [">= 1.2.8"])
  s.add_development_dependency(%q<roodi>, [">= 2.1.0"])
  s.add_development_dependency(%q<rake>, [">= 0"])

  # For Test Code Coverage
  s.add_development_dependency('coveralls') unless RUBY_VERSION == '1.8.7'

end
