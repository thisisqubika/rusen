require 'rusen/version'
require 'rusen/settings'
require 'rusen/notifier'

# Rusen is a util to help you with the tracking on the
#   application exceptions, this could be used on any
#   ruby project. The exceptions can be sent to different
#   outputs depending on your apps requirements.
module Rusen

  @settings = Settings.new

  # Returns the global settings for rusen.
  #
  # This settings apply to the notifications sent with Rusen.notify
  #
  # @return [Rusen::Settings] rusen global settings.
  def self.settings
    @settings
  end

  # (see Rusen::Notifier#notify)
  def self.notify(exception, request = {}, environment = {}, session = {})
    notifier.notify(exception, request, environment, session)
  end

  def self.notifier
    @notifier || Notifier.new(@settings)
  end

end
