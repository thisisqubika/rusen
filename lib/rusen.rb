require 'rusen/version'
require 'rusen/settings'
require 'rusen/notifier'

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