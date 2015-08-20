<p align="center">
  <a href="http://moove-it.github.io/rusen/">
    <img src="https://moove-it.github.io/rusen/images/logo.png" alt="Rusen" />
  </a>
</p>

<p align="center">
  <a href="https://badge.fury.io/rb/rusen">
    <img src="https://badge.fury.io/rb/rusen.png" alt="Gem Version">
  </a>
  <a href="https://codeclimate.com/github/Moove-it/rusen">
    <img src="https://codeclimate.com/github/Moove-it/rusen.png" alt="Code Climate">
  </a>
  <a href="https://travis-ci.org/moove-it/rusen">
    <img src="https://secure.travis-ci.org/moove-it/rusen.png?branch=master" alt="Build Status">
  </a>
  <a href="https://coveralls.io/github/moove-it/rusen?branch=master">
    <img src="https://coveralls.io/repos/moove-it/rusen/badge.svg?branch=master&service=github" alt="Coverage Status">
  </a>
  <a href="https://inch-ci.org/github/moove-it/rusen">
    <img src="https://inch-ci.org/github/moove-it/rusen.svg?branch=master" alt="Documentation Coverage">
  </a>
  <a href="http://www.rubydoc.info/github/moove-it/rusen">
    <img src="https://img.shields.io/badge/yard-docs-blue.svg" alt="Documentation">
  </a>
</p>

The Ruby Simple Exception Notification (a.k.a Rusen) gem provides a simple way for logging and sending errors in any Ruby application.

Notifications include information about the current request, session, environment. They also provide a backtrace of the exception.

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

Rusen.settings.sender_address = 'oops@example.org'
Rusen.settings.exception_recipients = %w(dev_team@example.org)
Rusen.settings.smtp_settings = {
  :address              => 'smtp.gmail.com',
  :port                 => 587,
  :domain               => 'example.org',
  :authentication       => :plain,
  :user_name            => 'dev_team@example.org',
  :password             => 'xxxxxxx',
  :enable_starttls_auto => true
}
```

And then you can start sending notifications:

```ruby
begin
  method.call
rescue Exception => exception
  Rusen.notify(exception)
end
```

This way, if you modify the notifications settings at runtime, every notification sent afterwards will use the new 
settings.

### With local configuration

This method lets you have more control when notifying. You may want for example to send an email when a particular 
exception occurs and just print to stdout otherwise.
To achieve this you can do the following:

```ruby
@email_notifier = Rusen::Notifier.new(@email_settings)

@stdout_settings = Rusen::Settings.new
@stdout_settings.outputs = [:backtrace]

@stdout_notifier = Rusen::Notifier.new(@stdout_settings)
```

and then:
```ruby
begin
  method.call
rescue SmallException => exception
  @stdout_notifier.notify(exception)
end
```

Middleware
---
Rusen comes with a Rack and rails special (soon to come) middleware for easy usage.

### Rack
To use Rusen in any Rack application you just have to add the following code somewhere in your app 
(ex: config/initializers/rusen.rb):

```ruby
require 'rusen/middleware/rusen_rack'

use Rusen::Middleware::RusenRack,
    :outputs => [:io, :email],
    :sections => [:backtrace, :request, :session, :environment],
    :email_prefix => '[ERROR] ',
    :sender_address => 'oops@example.org',
    :exception_recipients => %w(dev_team@example.org),
    :smtp_settings => {
      :address              => 'smtp.gmail.com',
      :port                 => 587,
      :domain               => 'example.org',
      :authentication       => :plain,
      :user_name            => 'dev_team@example.org',
      :password             => 'xxxxxxx',
      :enable_starttls_auto => true
    }
```

This will capture any unhandled exception, send an email and write a trace in stdout.

Settings
---

### Outputs

Currently supported outputs are :io, :lo4r, :pony and :mail. More outputs are easy to add so you can customize Rusen to 
your needs.

Note: :io will only print to stdout for the time being, but there are plans to extend it to anything that Ruby::IO 
supports.

Pony, lo4r and Mail outputs require additional gems to work.

To use Pony add this to your Gemfile:

```ruby
  gem 'pony'
```

To use mail, add this to your Gemfile:

```ruby
  gem 'mail'
```

To use log4r, add this to your Gemfile:

```ruby
  gem 'log4r'
```

### Sections

You can choose the output sections simply by setting the appropriate values in the configuration.

### Exclude if

Here you can pass a block that will receive the error. If the block returns false, then the error will be notified.

### Email settings

All the email settings are self explanatory, but you can contact hello+rusen@moove-it.com if any of them needs clarification.

If you are running Rusen inside **Rails** and you have configured smtp_settings for your app 
Rusen will use that settings by default.

### Log4r settings

* logger_name _(required)_: Logger used for logging errors.
* log4r_config_file _(optional)_: YAML file that contains Log4r configuration. 

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

You can configure it with the global Rusen configuration, ex:

```ruby
require 'rusen/sidekiq'

Rusen.settings.sender_address = 'oops@example.org'
Rusen.settings.exception_recipients = %w(dev_team@example.org)
Rusen.settings.smtp_settings = {
  :address              => 'smtp.gmail.com',
  :port                 => 587,
  :domain               => 'example.org',
  :authentication       => :plain,
  :user_name            => 'dev_team@example.org',
  :password             => 'xxxxxxx',
  :enable_starttls_auto => true
}
```

Rusen supports versions ~> 2 and ~> 3 of sidekiq.

## Contributors

See the [Network View](https://github.com/moove-it/rusen/network) and the [CHANGELOG](https://github.com/moove-it/rusen/blob/master/CHANGELOG.md)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests for it. This is important so we don't break it in a future version unintentionally.
6. Create a new Pull Request

## Legal

Rusen is released under the [MIT License](http://opensource.org/licenses/MIT).

[documentation]: http://http://www.rubydoc.info/github/moove-it/rusen
[homepage]: http://moove-it.github.io/rusen/
