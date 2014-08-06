[RU]by [S]imple [E]xception [N]otification
====

The Ruby Simple Exception Notification (a.k.a Rusen) gem provides a simple way for logging and sending errors in any ruby application.

The notification includes information about the current request, session, environment and also gives a backtrace of the exception.

| Project                 |  Rusen   |
|------------------------ | ----------------- |
| gem name                |  rusen   |
| license                 |  MIT              |
| moldiness               |  [![Maintainer Status](http://stillmaintained.com/Moove-it/rusen.png)](http://stillmaintained.com/Moove-it/rusen) |
| version                 |  [![Gem Version](https://badge.fury.io/rb/rusen.png)](http://badge.fury.io/rb/rusen) |
| dependencies            |  [![Dependency Status](https://gemnasium.com/Moove-it/rusen.png)](https://gemnasium.com/Moove-it/rusen) |
| code quality            |  [![Code Climate](https://codeclimate.com/github/Moove-it/rusen.png)](https://codeclimate.com/github/Moove-it/rusen) |
| continuous integration  |  [![Build Status](https://secure.travis-ci.org/Moove-it/rusen.png?branch=master)](https://travis-ci.org/Moove-it/rusen) |
| test coverage           |  [![Coverage Status](https://coveralls.io/repos/Moove-it/rusen/badge.png)](https://coveralls.io/r/Moove-it/rusen) |
| homepage                |  [https://github.com/Moove-it/rusen][homepage] |
| documentation           |  [http://rdoc.info/github/Moove-it/rusen/frames][documentation] |
| author                  |  [Adrian Gomez](https://coderbits.com/Moove-it) |

Installation
---

Just add the following line in your Gemfile

```ruby
gem 'rusen'
```

Usage
---

### With global configuration

The easiest way to use it is with global configuration.

First you configure Rusen
```ruby
require 'rusen'

Rusen.settings.outputs = [:io, :email]
Rusen.settings.sections = [:backtrace, :request, :session, :environment]
Rusen.settings.email_prefix = '[ERROR] '
Rusen.settings.sender_address = 'some_email@example.com'
Rusen.settings.exception_recipients = %w(dev_team@example.com test_team@example.com)
Rusen.settings.smtp_settings = {
  :address              => 'smtp.gmail.com',
  :port                 => 587,
  :domain               => 'example.org',
  :authentication       => :plain,
  :user_name            => 'dev_team@moove-it.com',
  :password             => 'xxxxxxx',
  :enable_starttls_auto => true
}
```
And the you can start sending notifications:
```ruby
begin
  method.call
rescue Exception => exception
  Rusen.notify(exception)
end
```
This way, if you modify the notifications settings at runtime, every notification sent afterwards will use the new settings.

### With local configuration

This method lets you have more control when notifying. You may want for example to send an email when a particular exception occurs and just print to stdout otherwise.
To achieve this you can do the following:
```ruby
@email_settings = Settings.new
@email_settings.outputs = settings[:email]
Rusen.settings.sections = [:backtrace, :request, :session]
@email_settings.email_prefix = '[ERROR] '
@email_settings.sender_address = 'some_email@example.com'
@email_settings.exception_recipients = %w(dev_team@example.com test_team@example.com)
@email_settings.smtp_settings = {
                                  :address              => 'smtp.gmail.com',
                                  :port                 => 587,
                                  :domain               => 'example.org',
                                  :authentication       => :plain,
                                  :user_name            => 'dev_team@moove-it.com',
                                  :password             => 'xxxxxxx',
                                  :enable_starttls_auto => true
                                }

@email_notifier = Notifier.new(@email_settings)

@stdout_settings = Settings.new
@stdout_settings.outputs = settings[:io]
Rusen.settings.sections = [:backtrace]

@stdout_notifier = Notifier.new(@stdout_settings)
```
and then:
```ruby
begin
  method.call
rescue SmallException => exception
  @stdout_notifier.notify(exception)
rescue BigException => exception
  @email_notifier.notify(exception)
end
```

Middleware
---
Rusen comes with a rack and rails special (soon to come) middleware for easy usage.

### Rack
To use Rusen in any rack application you just have to add the following code somewhere in your app (ex: config/initializers/rusen.rb):
```ruby
require 'rusen/middleware/rusen_rack'

use Rusen::Middleware::RusenRack,
    :outputs => [:io, :email],
    :sections => [:backtrace, :request, :session, :environment],
    :email_prefix => '[ERROR] ',
    :sender_address => 'some_email@example.com',
    :exception_recipients => %w(dev_team@example.com test_team@example.com),
    :smtp_settings => {
                        :address              => 'smtp.gmail.com',
                        :port                 => 587,
                        :domain               => 'example.org',
                        :authentication       => :plain,
                        :user_name            => 'dev_team@moove-it.com',
                        :password             => 'xxxxxxx',
                        :enable_starttls_auto => true
                      }
```
This will capture any unhandled exception, send an email and write a trace in stdout.

Settings
---
### Outputs
Currently supported outputs are :io, :lo4r, :pony and :mail. More outputs are easy to add so you can customize Rusen to your needs.

Note: :io will only print to stdout for the time being, but there are plans to extend it to anything that Ruby::IO supports.

Pony, lo4r and Mail outputs require additional gems to work.

To use pony add this to your Gemfile:
```ruby
  gem 'pony'
```

To use mail add this to your Gemfile:
```ruby
  gem 'mail'
```

To use log4r add this to your Gemfile:
```ruby
  gem 'log4r'
```

### Sections
You can choose the output sections simply by setting the appropriate values in the configuration.

### Exclude if
Here you can pass a block that will receive the error. If the block returns false, then the error will be notified.

### Email settings
All the email settings are self explanatory, but you can contact me if any of them needs clarification.

### Log4r settings
* logger_name _(required)_: Logger used for logging errors.
* log4r_config_file _(optional)_: YAML file that contains Log4r configuration. Rusen will load that file when given.

Sample of Log4r configuration file contents:

```
log4r_config:
  loggers:
    - name: error_notifications
      level: ERROR
      trace: false
      outputters:
        - logfile
        - stdoout

  outputters:
    - type: FileOutputter
      name: logfile
      filename: 'log/service.log'

    - type: StdoutOutputter
      name: stdout
```

Sidekiq
---
Rusen comes with sidekiq integration builtin to use just add this to your sidekiq initializer:
```ruby
require 'rusen/sidekiq'
```
You can configure it with the global rusen configuration, ex:
```ruby
require 'rusen/sidekiq'

Rusen.settings.sender_address = 'some_email@example.com'
Rusen.settings.exception_recipients = %w(dev_team@example.com test_team@example.com)
Rusen.settings.smtp_settings = {
  :address              => 'smtp.gmail.com',
  :port                 => 587,
  :domain               => 'example.org',
  :authentication       => :plain,
  :user_name            => 'dev_team@moove-it.com',
  :password             => 'xxxxxxx',
  :enable_starttls_auto => true
}
```

Rusen supports versions ~> 2 and ~> 3 of sidekiq.

Extending to more outputs
---
Soon to come!

## Authors

Adrian Gomez is the author of the code, and current maintainer.

## Contributors

See the [Network View](https://github.com/Moove-it/rusen/network) and the [CHANGELOG](https://github.com/Moove-it/rusen/blob/master/CHANGELOG.md)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
6. Create new Pull Request

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically,
if a minor or patch version is released that breaks backward
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a
dependency on this gem using the [Pessimistic Version Constraint][pvc] with two digits of precision.

For example:

    spec.add_dependency 'rusen', '~> 0.0.2'

## Legal

* MIT License - See LICENSE file in this project
* Copyright (c) 2013 Adrian Gomez

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74
[documentation]: http://rdoc.info/github/Moove-it/rusen/frames
[homepage]: https://github.com/Moove-it/rusen
