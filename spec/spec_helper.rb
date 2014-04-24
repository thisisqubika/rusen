require 'rspec'
require 'shoulda'

# For code coverage, must be required before all application / gem / library code.
if RUBY_VERSION >= '1.9.2'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start
end

require 'rusen'
