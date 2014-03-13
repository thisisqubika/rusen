require 'rusen/version'
require 'rusen/settings'
require 'rusen/notifier'

module Rusen

  attr_writer :settings, :notifier

  # Returns the global settings for rusen.
  #
  # This settings apply to the notifications sent with Rusen.notify
  #
  # @return [Rusen::Settings] rusen global settings.
  def self.settings
    @settings
  end

  # (see Rusen::Notifier#notify)
  def self.notify(exception, request = nil, environment = nil, session = nil, custom_data = nil, message = nil)
    if @notifier.is_a?(Rusen::Notifier)
      @notifier.notify(exception, request, environment, session, custom_data, message)
    else
      warn "Rusen has not been configured.  Configure with Rusen.configure do {|settings| settings.outputs = [:io] }."
    end
  end

  def self.configure &block
    @settings ||= Rusen::Settings.new
    yield @settings if block_given?

    # Gracefully handle deprecated config values.
    if @settings.outputs.include?(:email)
      index = @settings.outputs.index :email # returns nil if not found
      @settings.outputs[index] = :pony if index
    end
    @notifier = Rusen::Notifier.new(@settings)
  end

end
