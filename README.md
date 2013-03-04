[RU]by [S]imple [E]xception [N]otification
====

The Ruby Simple Exception Notification (a.k.a Rusen) gem provides a simple way for logging and sending errors in any ruby application.

The notification includes information about the current request, session, environment and also gives a backtrace of the exception.

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
Currently supported outputs are :io and :email. More outputs are easy to add so you can customize Rusen to your needs.

Note: :io will only print to stdout for the time being, but there are plans to extend it to anything that Ruby::IO supports.

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

Extending to more outputs
---
Soon to come!
