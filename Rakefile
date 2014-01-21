# encoding: utf-8
#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

require 'roodi'
require 'roodi_task'
RoodiTask.new do |t|
  t.verbose = false
end

task :default => :spec

namespace :test do
  desc 'Test against all supported Rails versions'
  task :all do
    if RUBY_VERSION == '1.8.7'
      %w( 2.2.x ).each do |rails_version|
        sh "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{rails_version}' bundle --quiet"
        sh "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{rails_version}' bundle exec rspec spec"
      end
    elsif RUBY_VERSION == '1.9.2'
      %w( 2.3.x 3.0.x 3.1.x 3.2.x ).each do |rails_version|
        sh "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{rails_version}' bundle --quiet"
        sh "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{rails_version}' bundle exec rspec spec"
      end
    elsif RUBY_VERSION == '1.9.3'
      %w( 3.2.x 4.0.x ).each do |rails_version|
        sh "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{rails_version}' bundle --quiet"
        sh "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{rails_version}' bundle exec rspec spec"
      end
    elsif RUBY_VERSION == '2.0.0'
      %w( 3.2.x 4.0.x ).each do |rails_version|
        sh "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{rails_version}' bundle --quiet"
        sh "BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{rails_version}' bundle exec rspec spec"
      end
    end
  end
end

#require File.expand_path('../lib/rusen/version', __FILE__)
#require 'rdoc'
#require 'rdoc/task'
#RDoc::Task.new do |rdoc|
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title    = "Rusen #{Rusen::VERSION}"
#  rdoc.options << '--line-numbers'
#  rdoc.rdoc_files.include('README*')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end

Bundler::GemHelper.install_tasks
