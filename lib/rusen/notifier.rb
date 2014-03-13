require 'rusen/notifier_loader'
require 'rusen/exception_context'

module Rusen

  class Notifier

    def initialize(settings)
      raise ArgumentError, "Rusen::Notifier must be initialized with an instance of Rusen::Settings, but was given a: #{settings.class}" unless settings.is_a?(Rusen::Settings)
      @settings = settings

      @notifiers = []
      @settings.outputs.each do |ident|
        ident = NotifierLoader.check_deprecation(ident)
        # For notifiers bundled in this gem
        klass = NotifierLoader.load_klass(ident)
        if klass.nil?
          Notifiers.constants.each do |constant|
            klass = Notifiers.const_get(constant)
            next unless klass.is_a?(Class)
            break if ident == klass.identification_symbol
            klass = nil
          end
        end
        raise "Unable to load Output Notifier identified by: #{ident}" if !klass.is_a?(Class)
        register(klass)
      end
    end

    def register(notifier_class)
      @notifiers << notifier_class.new(@settings)
    end

    # Sends a notification to the configured outputs.
    #
    # @param [Exception] exception The error.
    # @param [Hash<Object, Object>] request The request params (redacted).
    # @param [Hash<Object, Object>] environment The environment status.
    # @param [Hash<Object, Object>] session The headers to be sent back in the response.
    # @param [Hash<Object, Object>] custom_data A Custom Hash of stuff to render.
    # @param [String] message Optional additional message, (not the exception.message) to be sent with error.
    def notify(exception, request = {}, environment = {}, session = {}, custom_data = {}, message = nil)
      begin
        notification = ExceptionContext.new(exception, request, environment, session, custom_data, message)

        @notifiers.each do |notifier|
          notifier.notify(notification)
        end

      # We need to ignore all the exceptions thrown by the notifiers.
      rescue StandardError => ex
        log("Rusen: Some or all the notifiers failed to send the notification.\nReason: #{ex.class}\n#{ex.message}\n#{ex.backtrace.join("\n")}")
      end
    end

  end

end
