require 'rusen/settings'
require 'rusen/notifier'
#require 'rusen/notification'

module Rusen

  @settings = Settings.new
  @notifier = Notifier.new(@settings)

  def self.settings
    @settings
  end

  def self.notify(exception, request = nil, environment = nil, session = nil)
    @notifier.notify(exception, request, environment, session)
  end

end