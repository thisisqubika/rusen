require 'rspec'
require 'shoulda'

# For code coverage, must be required before all application / gem / library code.
if RUBY_VERSION >= "1.9.2"
  require 'simplecov'
  require 'coveralls'
  Coveralls.wear!
end

require 'rusen'
