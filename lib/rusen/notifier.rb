require 'rusen/notifiers'
require 'rusen/notification'

module Rusen

  class Notifier

    def initialize(settings)
      @settings = settings

      @notifiers = []
      @settings.outputs.each do |ident|
        ident = Notifiers.check_deprecation(ident)
        # For notifiers bundled in this gem
        klass = Notifiers.load_klass(ident)
        if klass.nil?
          Notifiers.constants.each do |constant|
            klass = Notifiers.const_get(constant)
            next unless klass.is_a?(Class)
            break if ident == klass.identification_symbol
            klass = nil
          end
        end
        raise "Unable to load Output Notifier identified by: #{ident}" if klass.nil? || !klass.is_a?(Class)
        register(klass)
      end
    end

    def register(notifier_class)
      @notifiers << notifier_class.new(@settings)
    end

    # Sends a notification to the configured outputs.
    #
    # @param [Exception] exception The error.
    # @param [Hash<Object, Object>] request The request params
    # @param [Hash<Object, Object>] environment The environment status.
    # @param [Hash<Object, Object>] session The session status.
    def notify(exception, request = {}, environment = {}, session = {})
      begin
        notification = Notification.new(exception, request, environment, session)

        @notifiers.each do |notifier|
          notifier.notify(notification)
        end

      # We need to ignore all the exceptions thrown by the notifiers.
      rescue Exception
        warn('Rusen: Some or all the notifiers failed to sent the notification.')
      end
    end

  end

end
